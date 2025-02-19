//
//  Item.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 19/02/2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
