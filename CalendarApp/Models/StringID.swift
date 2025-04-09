//
//  UUID.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 09/04/2025.
//
import SwiftData

@Model
final class StringID: Identifiable {
    var id: String

    init(_ id: String) {
        self.id = id
    }
}
