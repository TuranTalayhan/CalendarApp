//
//  EventsView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 19/02/2025.
//

import SwiftData
import SwiftUI

struct EventsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var events: [Event]
    @State private var searchText: String = ""
    private var dataService: DataService {
        DataService(context: modelContext)
    }

    private var selectedEvents: [Event] {
        if searchText.isEmpty {
            return events.sorted()
        } else {
            return events.filter { $0.title.lowercased().contains(searchText.lowercased()) }
                .sorted()
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(selectedEvents) { event in
                    NavigationLink(destination: EventDetailView(event: event)) {
                        Text(event.title)
                    }
                }
                .onDelete(perform: deleteEvents)
            }
            .navigationTitle("Events")
            .searchable(text: $searchText)
        }
    }

    private func deleteEvents(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                dataService.deleteEvent(selectedEvents[index])
            }
        }
    }
}

#Preview {
    EventsView()
        .modelContainer(for: Event.self, inMemory: true)
}
