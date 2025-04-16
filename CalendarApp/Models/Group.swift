//
//  Group.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import Foundation
import SwiftData

@Model
final class Group: Identifiable {
    var id: String
    var name: String
    var members: [StringID]
    var timestamp: Date = Date()

    init(id: String, name: String, members: [StringID]) {
        self.id = id
        self.name = name
        self.members = members
    }
}
