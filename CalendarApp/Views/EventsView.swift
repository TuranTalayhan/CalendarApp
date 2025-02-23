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

    var body: some View {
        NavigationStack {
            List {
                ForEach(events) { event in
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
                modelContext.delete(events[index])
            }
        }
    }
}

#Preview {
    EventsView()
        .modelContainer(for: Event.self, inMemory: true)
}
