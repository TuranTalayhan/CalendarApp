//
//  NewEventView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 21/02/2025.
//

import SwiftData
import SwiftUI

struct NewEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var groups: [Group]
    @AppStorage("isNotificationAuthorized") private var isNotificationAuthorized: Bool = false
    @Binding var showSheet: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var title: String = ""
    @State private var isAllDay: Bool = false
    @State private var url: String = ""
    @State private var notes: String = ""
    @State private var showInvalidDatesAlert: Bool = false
    @State private var alert: Int = -1
    @State private var assignee: User?
    @State private var selectedGroup: Group?
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    private var dateFormatService: DateFormatService {
        DateFormatService()
    }

    private var userNotificationService: UserNotificationService {
        UserNotificationService()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $title)
                }

                Section {
                    Toggle("All-Day", isOn: $isAllDay)
                    DatePicker("Starts", selection: $startDate, displayedComponents: isAllDay == true ? [.date] : [.date, .hourAndMinute])
                    DatePicker("Ends", selection: $endDate, displayedComponents: isAllDay == true ? [.date] : [.date, .hourAndMinute])
                }

                Section {
                    AlertPicker(alert: $alert)
                }

                Section {
                    GroupPicker(groups: groups, selectedGroup: $selectedGroup)
                    AssigneePicker(group: selectedGroup, assignee: $assignee)
                }

                Section {
                    TextField("URL", text: $url)
                        .autocapitalization(.none)
                    TextField("Notes", text: $notes, axis: .vertical)
                }
            }
            .navigationTitle("New Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        guard startDate < endDate else {
                            showInvalidDatesAlert = true
                            return
                        }
                        let newURL: URL?
                        if url.starts(with: "https://") || url.starts(with: "http://") {
                            newURL = URL(string: url)
                        } else if !url.isEmpty {
                            newURL = URL(string: "https://\(url)")
                        } else {
                            newURL = nil
                        }
                        if notes.isEmpty {
                            addEvent(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, url: newURL, notes: nil)
                            return
                        }
                        addEvent(title: title, isAllDay: isAllDay, startDate: startDate, endDate: endDate, url: newURL, notes: notes)
                    }) {
                        Text("Add")
                    }.disabled(title.isEmpty)
                        .alert(isPresented: $showInvalidDatesAlert) {
                            Alert(title: Text("Cannot Save Event"), message: Text("The start date must be before the end date"))
                        }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { showSheet = false }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }

    private func addEvent(title: String, isAllDay: Bool, startDate: Date, endDate: Date, url: URL?, notes: String?) {
        withAnimation {
            let event = dataService.addEvent(title, isAllDay, startDate, endDate, url, notes, alert, selectedGroup, assignee)

            FirebaseService.shared.saveEvent(event)

            if isNotificationAuthorized && alert >= 0 {
                userNotificationService.sendNotification(Event(title: title, allDay: isAllDay, startTime: startDate, endTime: endDate, url: url, notes: notes, alert: alert, group: selectedGroup, assignedTo: assignee), dateFormatService: dateFormatService, minutesBefore: alert)
            } else if alert >= 0 {
                Task {
                    isNotificationAuthorized = await userNotificationService.requestNotificationAuthorization()
                }
            }
            showSheet = false
        }
    }
}

#Preview {
    @State @Previewable var isPresented = false
    NavigationStack {
        Button(action: { isPresented = true }) {
            Text("Test")
        }
        .sheet(isPresented: $isPresented) { NewEventView(
            showSheet: $isPresented, startDate: .constant(Date()), endDate: .constant(Date()))
        }
    }
}
