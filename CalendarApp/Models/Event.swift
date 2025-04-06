//
//  Item.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 19/02/2025.
//

import Foundation
import SwiftData

@Model
final class Event: Comparable, Identifiable {
    var id: String
    var title: String
    var allDay: Bool
    var startDate: Date
    var endDate: Date
    var url: URL?
    var notes: String?
    var alert: Int
    var group: Group?
    var assignedTo: User?
    var timestamp: Date = Date()

    init(id: String, title: String, allDay: Bool, startTime: Date, endTime: Date, url: URL?, notes: String?, alert: Int, group: Group?, assignedTo: User?) {
        self.id = id
        self.title = title
        self.allDay = allDay
        self.startDate = startTime
        self.endDate = endTime
        self.url = url
        self.notes = notes
        self.alert = alert
        self.group = group
        self.assignedTo = assignedTo
    }

    static func < (lhs: Event, rhs: Event) -> Bool {
        lhs.startDate < rhs.startDate
    }

    static func > (lhs: Event, rhs: Event) -> Bool {
        lhs.startDate > rhs.endDate
    }
}
