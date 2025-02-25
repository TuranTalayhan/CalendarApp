//
//  EditEventView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 23/02/2025.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var isPresented: Bool
    let parentDismiss: DismissAction
    let event: Event
    @State private var title: String = ""
    @State private var allDay: Bool = false
    @State private var startDate: Date = .init()
    @State private var endDate: Date = .init()
    @State private var url: String = ""
    @State private var notes: String = ""
    @State private var showingConfirmation: Bool = false
    @State private var showAlert: Bool = false
    private var dataService: DataService {
        DataService(context: modelContext)
    }

    private var userNotificationService: UserNotificationService {
        UserNotificationService()
    }

    private var updated: Bool {
        title != event.title ||
            allDay != event.allDay ||
            startDate != event.startDate ||
            endDate != event.endDate ||
            url != event.url?.absoluteString ?? "" ||
            notes != event.notes ?? ""
    }

    init(isPresented: Binding<Bool>, parentDismiss: DismissAction, event: Event) {
        self._isPresented = isPresented
        self.parentDismiss = parentDismiss
        self.event = event
        self._title = State(initialValue: event.title)
        self._allDay = State(initialValue: event.allDay)
        self._startDate = State(initialValue: event.startDate)
        self._endDate = State(initialValue: event.endDate)
        self._url = State(initialValue: event.url?.absoluteString ?? "")
        self._notes = State(initialValue: event.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Title", text: $title)
                }
                Section {
                    Toggle("All-Day", isOn: $allDay)
                    DatePicker("Starts", selection: $startDate, displayedComponents: allDay == true ? [.date] : [.date, .hourAndMinute])
                    DatePicker("Ends", selection: $endDate, displayedComponents: allDay == true ? [.date] : [.date, .hourAndMinute])
                }

                Section {
                    TextField("URL", text: $url)
                    TextField("Notes", text: $notes, axis: .vertical)
                }

                Button(role: .destructive, action: { showingConfirmation = true }) {
                    HStack {
                        Text("Delete Event")
                    }
                    .frame(maxWidth: .infinity)
                }
                .confirmationDialog("Are you sure you want to delete this event?", isPresented: $showingConfirmation, titleVisibility: .visible) {
                    Button("Delete Event", role: .destructive, action: deleteEvent)
                    Button("Cancel", role: .cancel, action: {})
                }
            }
            .navigationTitle("Edit Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        guard startDate < endDate else {
                            showAlert = true
                            return
                        }
                        save()
                        isPresented = false
                    }) {
                        Text("Done")
                    }
                    .disabled(!updated)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Cannot Save Event"), message: Text("The start date must be before the end date"))
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }

    private func save() {
        let newURL: URL?
        if url.starts(with: "https://") || url.starts(with: "http://") {
            newURL = URL(string: url)
        } else if !url.isEmpty {
            newURL = URL(string: "https://\(url)")
        } else {
            newURL = nil
        }
        event.title = title
        event.allDay = allDay
        event.startDate = startDate
        event.url = newURL
        event.notes = notes.isEmpty ? nil : notes
        userNotificationService.removeAllNotificationsWithIdentifiers(identifiers: [event.id])
        userNotificationService.sendNotification(event)
    }

    private func deleteEvent() {
        withAnimation {
            dataService.deleteEvent(event)
            isPresented = false
            parentDismiss()
        }
    }
}

#Preview {
    @Previewable @Environment(\.dismiss) var dismiss: DismissAction
    EditEventView(isPresented: .constant(true), parentDismiss: dismiss, event: Event(title: "Event name", allDay: false, startTime: Date(), endTime: Date(), url: URL(string: "www.apple.com"), notes: "Note content"))
}
