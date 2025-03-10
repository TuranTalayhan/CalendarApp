//
//  User.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 10/03/2025.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String
    var username: String
    var password: String
    var email: String
}
