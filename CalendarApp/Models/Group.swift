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
    var members: [User]
    var timeStamp: Date = Date()

    init(name: String, members: [User]) {
        self.id = UUID().uuidString
        self.name = name
        self.members = members
    }
}
