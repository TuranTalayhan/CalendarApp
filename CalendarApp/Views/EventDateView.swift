//
//  EventDateView.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 04/03/2025.
//

import SwiftUI

struct EventDateView: View {
    let event: Event
    private var dateFormatService: DateFormatService {
        DateFormatService()
    }

    var body: some View {
        if dateFormatService.formatDayWithMonthAndYear(event.startDate) == dateFormatService.formatDayWithMonthAndYear(event.endDate) {
            Text("\(dateFormatService.formatDayOfWeek(event.startDate)), \(event.startDate, style: .date)")
                .foregroundColor(.secondary)
            Text(event.allDay ? "All day" : "from \(event.startDate, style: .time) to \(event.endDate, style: .time)")
                .foregroundColor(.secondary)
                .padding(.bottom)
        } else if event.allDay {
            Text("All day from \(event.startDate, style: .date)")
                .foregroundColor(.secondary)
            Text("to \(event.endDate, style: .date)")
                .foregroundColor(.secondary)
                .padding(.bottom)
        } else {
            Text("from \(event.startDate, style: .time) \(dateFormatService.formatDayOfWeek(event.startDate)), \(event.startDate, style: .date)")
                .foregroundColor(.secondary)
            Text("to \(event.endDate, style: .time) \(dateFormatService.formatDayOfWeek(event.endDate)), \(event.endDate, style: .date)")
                .foregroundColor(.secondary)
                .padding(.bottom)
        }
    }
}

#Preview {
    EventDateView(event: Event(title: "Event name", allDay: true, startTime: Date(), endTime: Date(), url: URL(string: "www.apple.com"), notes: "Note content", alert: 1))
}
