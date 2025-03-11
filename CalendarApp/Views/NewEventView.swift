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
    @Binding var showSheet: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date
    @State private var title: String = ""
    @State private var isAllDay: Bool = false
    @State private var url: String = ""
    @State private var notes: String = ""
    @State private var showAlert: Bool = false
    @State private var alert: Int = -1
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
                    Picker("Alert", selection: $alert) {
                        Text("None").tag(-1)
                        Text("At time of event").tag(0)
                        Text("5 minutes before").tag(5)
                        Text("10 minutes before").tag(10)
                        Text("15 minutes before").tag(15)
                        Text("30 minutes before").tag(30)
                        Text("1 hour before").tag(60)
                        Text("2 hours before").tag(60 * 2)
                        Text("1 day before").tag(60 * 24)
                        Text("2 day before").tag(60 * 24 * 2)
                        Text("1 week before").tag(60 * 24 * 7)
                    }
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
                            showAlert = true
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
                        .alert(isPresented: $showAlert) {
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
            dataService.addEvent(title, isAllDay, startDate, endDate, url, notes, alert)

            if isNotificationAuthorized && alert >= 0 {
                userNotificationService.sendNotification(Event(title: title, allDay: isAllDay, startTime: startDate, endTime: endDate, url: url, notes: notes, alert: alert), dateFormatService: dateFormatService, minutesBefore: alert)
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
