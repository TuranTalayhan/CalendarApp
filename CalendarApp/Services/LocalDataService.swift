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

    func addEvent(_ id: String, _ title: String, _ isAllDay: Bool, _ startDate: Date, _ endDate: Date, _ url: URL?, _ notes: String?, _ alert: Int, _ group: Group? = nil, _ assignedTo: User? = nil) -> Event {
        let newEvent = Event(id: id, title: title, allDay: isAllDay, startTime: startDate, endTime: endDate, url: url, notes: notes, alert: alert, group: group, assignedTo: assignedTo)
        modelContext.insert(newEvent)
        try? modelContext.save()
        return newEvent
    }

    func addGroup(_ id: String, _ name: String, _ members: [User]) -> Group {
        let newGroup = Group(id: id, name: name, members: members)
        modelContext.insert(newGroup)
        try? modelContext.save()
        return newGroup
    }

    func deleteEvent(_ event: Event) {
        userNotificationService.removeAllNotificationsWithIdentifiers(identifiers: [event.id])
        modelContext.delete(event)
        try? modelContext.save()
    }

    func deleteGroup(_ group: Group) {
        modelContext.delete(group)
        try? modelContext.save()
    }
}
