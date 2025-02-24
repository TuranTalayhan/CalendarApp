//
//  DateFormatService.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 24/02/2025.
//
import Foundation

class DateFormatService {
    func formatTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
    
    func formatDayOfWeek(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    func formatMonth(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }
    
    func formatYear(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func formatDay(_ date: Date, leadingZeroes: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = leadingZeroes ? "dd" : "d"
        return dateFormatter.string(from: date)
    }
    
    func formatDayWithMonthAndYear(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
}
