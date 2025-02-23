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

    init(context: ModelContext) {
        self.modelContext = context
    }

    func addEvent(_ title: String, _ isAllDay: Bool, _ startDate: Date, _ endDate: Date, _ url: URL?, _ notes: String?) {
        let newEvent = Event(title: title, allDay: isAllDay, startTime: startDate, endTime: endDate, url: url, notes: notes)
        modelContext.insert(newEvent)
        try? modelContext.save()
    }

    func deleteEvent(_ event: Event) {
        modelContext.delete(event)
        try? modelContext.save()
    }
}
