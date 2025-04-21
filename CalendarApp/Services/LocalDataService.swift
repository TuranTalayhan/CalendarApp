//
//  DataService.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 23/02/2025.
//

import Foundation
import SwiftData

class LocalDataService {
    private let modelContext: ModelContext
    private var userNotificationService: UserNotificationService {
        UserNotificationService()
    }

    init(context: ModelContext) {
        self.modelContext = context
    }

    func addEvent(_ id: String, _ title: String, _ isAllDay: Bool, _ startDate: Date, _ endDate: Date, _ url: URL?, _ notes: String?, _ alert: Int, _ group: String? = nil, _ assignedTo: String? = nil) -> Event {
        let newEvent = Event(id: id, title: title, allDay: isAllDay, startTime: startDate, endTime: endDate, url: url, notes: notes, alert: alert, group: group, assignedTo: assignedTo)
        modelContext.insert(newEvent)
        try? modelContext.save()
        return newEvent
    }

    func addEvents(_ events: [Event]) {
        for event in events {
            addEvent(event.id, event.title, event.allDay, event.startDate, event.endDate, event.url, event.notes, event.alert, event.group, event.assignedTo)
        }
    }

    func replaceEvents(with newEvents: [Event]) {
        do {
            try modelContext.delete(model: Event.self)

            addEvents(newEvents)

            try modelContext.save()
        } catch {
            print("Failed to replace events: \(error.localizedDescription)")
        }
    }

    func addGroup(_ id: String, _ name: String, _ members: [StringID]) -> Group {
        let newGroup = Group(id: id, name: name, members: members)
        modelContext.insert(newGroup)
        try? modelContext.save()
        return newGroup
    }

    func addGroups(_ groups: [Group]) {
        for group in groups {
            addGroup(group.id, group.name, group.members)
        }
    }

    func replaceGroups(with newGroups: [Group]) {
        do {
            try modelContext.delete(model: Group.self)

            addGroups(newGroups)

            try modelContext.save()
        } catch {
            print("Failed to replace groups: \(error.localizedDescription)")
        }
    }

    func deleteEvent(_ event: Event) {
        userNotificationService.removeAllNotificationsWithIdentifiers(identifiers: [event.id])
        modelContext.delete(event)
        try? modelContext.save()
    }

    func deleteEvents(_ events: [Event]) {
        for event in events {
            deleteEvent(event)
        }
    }

    func deleteGroup(_ group: Group) {
        let groupID = group.id

        let fetchDescriptor = FetchDescriptor<Event>(
            predicate: #Predicate { event in
                event.group == groupID
            }
        )

        do {
            let eventsToDelete = try modelContext.fetch(fetchDescriptor)

            for event in eventsToDelete {
                userNotificationService.removeAllNotificationsWithIdentifiers(identifiers: [event.id])
                modelContext.delete(event)
            }

            modelContext.delete(group)

            try modelContext.save()
        } catch {
            print("Error deleting group and associated events: \(error)")
        }
    }

    func deleteGroups(_ groups: [Group]) {
        for group in groups {
            deleteGroup(group)
        }
    }
}
