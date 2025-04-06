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
    @State private var temperatureAlert: Bool = false
    @State private var temperature: Double?
    private var dataService: LocalDataService {
        LocalDataService(context: modelContext)
    }

    private var dmiAPIService: DMIAPIService {
        DMIAPIService()
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.bottom)

            EventDateView(event: event)

            if let assignedTo = event.assignedTo {
                Text("Assignee")
                Text(assignedTo.username)
                    .foregroundColor(.secondary)
                Divider()
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
                    .padding(.bottom)
            }

            if let temp = temperature, temp != 0 {
                TemperatureView(temperature: temp)
            } else if temperature == nil {
                ProgressView()
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
        .alert(
            isPresented: $temperatureAlert)
        {
            Alert(title: Text("Data Unavailable"),
                  message: Text("Temperature data is unavailable for the selected date."))
        }
        .navigationTitle("Event Details")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            temperature = getTemperature(response: await fetchTemperature())
        }
        .onChange(of: temperature == 0) { temperatureAlert = true }
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

    private func fetchTemperature() async -> CoverageJSONResponse? {
        do {
            let response = try await dmiAPIService.fetchWeatherData()
            return response
        } catch {
            print("Error fetching Temperature data: \(error)")
            return nil
        }
    }

    private func getTemperature(response: CoverageJSONResponse?) -> Double {
        var dateString = event.startDate.ISO8601Format()

        if let tIndex = dateString.firstIndex(of: "T") {
            let tIndexAfterT = dateString.index(tIndex, offsetBy: 2)
            dateString = dateString[...tIndexAfterT] + ":00:00.000Z"
        }

        if let timeIndex = response?.domain.axes.t.values.firstIndex(of: dateString) {
            return (response?.ranges["temperature-0m"]?.values[timeIndex] ?? 273.15) - 273.15
        }

        return 0
    }

    private func deleteEvent() {
        withAnimation {
            FirebaseService.shared.deleteEvent(event)
            dataService.deleteEvent(event)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    EventDetailView(event: Event(id: UUID().uuidString, title: "Event name", allDay: true, startTime: Date(), endTime: Date(), url: URL(string: "www.apple.com"), notes: "Note content", alert: 1, group: Group(id: UUID().uuidString, name: "group name", members: []), assignedTo: User(id: "id1", username: "Turan", email: "turan@gmail.com")))
}
