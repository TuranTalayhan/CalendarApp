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
    var email: String?
    var password: String?
    var isLocalUser: Bool

    init(username: String, email: String? = nil, password: String? = nil, isLocalUser: Bool = false) {
        self.id = UUID().uuidString
        self.username = username
        self.email = email
        self.password = password
        self.isLocalUser = isLocalUser
    }
}
