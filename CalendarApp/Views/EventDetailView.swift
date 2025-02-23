//
//  EventDetailView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 21/02/2025.
//

import SwiftUI

struct EventDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.presentationMode) var presentationMode
    let event: Event

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)
            Text("\(dayOfWeek(event.startTime)), \(event.startTime, style: .date)")
                .foregroundColor(.secondary)
            Text(event.allDay ? "All day" : "from \(event.startTime, style: .time) to \(event.endTime, style: .time)")
                .foregroundColor(.secondary)
                .padding(.bottom)
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
            Button("Delete Event") {
                deleteEvent()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .foregroundColor(.red)
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }

    private func dayOfWeek(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    private func deleteEvent() {
        withAnimation {
            modelContext.delete(event)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    EventDetailView(event: Event(title: "Event name", allDay: false, startTime: Date(), endTime: Date(), url: URL(string: "www.apple.com"), notes: "Note content"))
}
