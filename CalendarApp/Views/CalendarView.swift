//
//  CalendarView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 20/02/2025.
//

import SwiftData
import SwiftUI

struct CalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    @State private var showSheet: Bool = false
    @State private var selectedDate: Date = .init()
    @State private var endDate: Date = .init()
    private var dataService: DataService {
        DataService(context: modelContext)
    }

    private var dateFormatService: DateFormatService {
        DateFormatService()
    }

    private var currentEvents: [Event] {
        let calendar = Calendar.current
        let selectedDay = calendar.startOfDay(for: selectedDate)
        return events.filter {
            let startDay = calendar.startOfDay(for: $0.startDate)
            let endDay = calendar.startOfDay(for: $0.endDate).addingTimeInterval(24 * 60 * 60)
            return (startDay ..< endDay).contains(selectedDay)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                }
                if !currentEvents.isEmpty {
                    Section(header: Text("\(dateFormatService.formatDay(selectedDate)) \(dateFormatService.formatMonth(selectedDate))"), footer: Text(dateFormatService.formatYear(selectedDate))) {
                        ForEach(currentEvents) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                Text(event.title)
                            }
                        }
                        .onDelete(perform: deleteEvents)
                    }
                }
            }
            .navigationTitle("Calendar")
            .sheet(isPresented: $showSheet) {
                NewEventView(showSheet: $showSheet, startDate: $selectedDate, endDate: $endDate)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        endDate = Calendar.current.date(byAdding: .hour, value: 1, to: selectedDate) ?? selectedDate
                        showSheet = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func deleteEvents(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                dataService.deleteEvent(currentEvents[index])
            }
        }
    }
}

#Preview {
    CalendarView()
}
