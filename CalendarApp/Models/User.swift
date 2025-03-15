//
//  User.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 11/03/2025.
//

import Foundation
import SwiftData

@Model
final class User: Identifiable {
    var id: String
    var username: String
    var email: String

    init(id: String = UUID().uuidString, username: String, email: String) {
        self.id = id
        self.username = username
        self.email = email
    }
}
