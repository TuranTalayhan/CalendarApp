//
//  NewEventView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 21/02/2025.
//

import SwiftUI

struct NewEventView: View {
    @Environment(\.modelContext) private var modelContext
    @AppStorage("isNotificationAuthorized") private var isNotificationAuthorized: Bool = false
    @Binding var isPresented: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var title: String = ""
    @State private var isAllDay: Bool = false
    @State private var url: String = ""
    @State private var notes: String = ""
    private var dataService: DataService {
        DataService(context: modelContext)
    }

    private var dateFormatService: DateFormatService {
        DateFormatService()
    }

    private var userNotificationService: UserNotificationService {
        UserNotificationService()
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    TextField("Title", text: $title)
                }

                Section {
                    Toggle("All-Day", isOn: $isAllDay)
                    DatePicker("Starts", selection: $startDate, displayedComponents: isAllDay == true ? [.date] : [.date, .hourAndMinute])
                    DatePicker("Ends", selection: $endDate, displayedComponents: isAllDay == true ? [.date] : [.date, .hourAndMinute])
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
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: { isPresented = false }) {
                        Text("Cancel")
                    }
                }
            }
        }
    }

    private func addEvent(title: String, isAllDay: Bool, startDate: Date, endDate: Date, url: URL?, notes: String?) {
        withAnimation {
            dataService.addEvent(title, isAllDay, startDate, endDate, url, notes)
            if isNotificationAuthorized {
                userNotificationService.sendNotification(Event(title: title, allDay: isAllDay, startTime: startDate, endTime: endDate, url: url, notes: notes), dateFormatService: dateFormatService)
            } else {
                Task {
                    isNotificationAuthorized = await userNotificationService.requestNotificationAuthorization()
                }
            }
            isPresented = false
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
            isPresented: $isPresented, startDate: .constant(Date()), endDate: .constant(Date()))
        }
    }
}
