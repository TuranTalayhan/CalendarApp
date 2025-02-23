//
//  Item.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 19/02/2025.
//

import Foundation
import SwiftData

@Model
final class Event {
    var title: String
    var allDay: Bool
    var startTime: Date
    var endTime: Date
    var url: URL?
    var notes: String?

    init(title: String, allDay: Bool, startTime: Date, endTime: Date, url: URL?, notes: String?) {
        self.title = title
        self.allDay = allDay
        self.startTime = startTime
        self.endTime = endTime
        self.url = url
        self.notes = notes
    }
}
