//
//  DataService.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 23/02/2025.
//

import Foundation
import SwiftData

class DataService {
    private let modelContext: ModelContext
    private var userNotificationService: UserNotificationService {
        UserNotificationService()
    }

    init(context: ModelContext) {
        self.modelContext = context
    }

    func addEvent(_ title: String, _ isAllDay: Bool, _ startDate: Date, _ endDate: Date, _ url: URL?, _ notes: String?, _ alert: Int) {
        let newEvent = Event(title: title, allDay: isAllDay, startTime: startDate, endTime: endDate, url: url, notes: notes, alert: alert)
        modelContext.insert(newEvent)
        try? modelContext.save()
    }

    func deleteEvent(_ event: Event) {
        userNotificationService.removeAllNotificationsWithIdentifiers(identifiers: [event.id])
        modelContext.delete(event)
        try? modelContext.save()
    }
}
