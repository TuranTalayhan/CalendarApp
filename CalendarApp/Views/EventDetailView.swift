//
//  EventDetailView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 21/02/2025.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
    let event: Event
    @State private var isPresented = false
    @State private var showingConfirmation: Bool = false
    private var dataService: DataService {
        DataService(context: modelContext)
    }

    private var dateFormatService: DateFormatService {
        DateFormatService()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            if dateFormatService.formatDayWithMonthAndYear(event.startDate) == dateFormatService.formatDayWithMonthAndYear(event.endDate) {
                Text("\(dateFormatService.formatDayOfWeek(event.startDate)), \(event.startDate, style: .date)")
                    .foregroundColor(.secondary)
                Text(event.allDay ? "All day" : "from \(event.startDate, style: .time) to \(event.endDate, style: .time)")
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            } else if event.allDay {
                Text("All day from \(event.startDate, style: .date)")
                    .foregroundColor(.secondary)
                Text("to \(event.endDate, style: .date)")
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            } else {
                Text("from \(event.startDate, style: .time) \(dateFormatService.formatDayOfWeek(event.startDate)), \(event.startDate, style: .date)")
                    .foregroundColor(.secondary)
                Text("to \(event.endDate, style: .time) \(dateFormatService.formatDayOfWeek(event.endDate)), \(event.endDate, style: .date)")
                    .foregroundColor(.secondary)
                    .padding(.bottom)
            }
            if let url = event.url {
                Text("URL")
                Link("\(url)", destination: url)
                Divider()
                    .padding(.bottom)
            }
            if let notes = event.notes, !notes.isEmpty {
                Text("Notes")
                Text(notes)
                    .foregroundColor(.secondary)
                Divider()
            }
            Spacer()
            Button(role: .destructive, action: { showingConfirmation = true }) {
                Text("Delete Event")
            }
            .confirmationDialog("Are you sure you want to delete this event?", isPresented: $showingConfirmation, titleVisibility: .visible) {
                Button("Delete Event", role: .destructive, action: deleteEvent)
                Button("Cancel", role: .cancel, action: {})
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.red)
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isPresented) {
            EditEventView(isPresented: $isPresented, parentDismiss: dismiss, event: event)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isPresented = true }) {
                    Text("Edit")
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func deleteEvent() {
        withAnimation {
            dataService.deleteEvent(event)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    EventDetailView(event: Event(title: "Event name", allDay: true, startTime: Date(), endTime: Date(), url: URL(string: "www.apple.com"), notes: "Note content"))
}
