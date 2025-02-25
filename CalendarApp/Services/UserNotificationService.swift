//
//  UserNotificationService.swift
//  CalendarApp
//
//  Created by Turan Talayhan on 24/02/2025.
//
import Foundation
import UserNotifications

class UserNotificationService {
    private let center = UNUserNotificationCenter.current()

    func sendNotification(_ event: Event, dateFormatService: DateFormatService = DateFormatService(), minutesBefore: Int = -1) {
        guard let date = Calendar.current.date(byAdding: .minute, value: -minutesBefore, to: event.startDate) else {
            return
        }

        let timeInterval = date.timeIntervalSinceNow

        guard timeInterval >= 0 else {
            print("Failed to schedule notification. Event has passed. \(timeInterval)")
            return
        }

        let content = UNMutableNotificationContent()
        content.title = event.title
        content.body = "Today at \(dateFormatService.formatTime(event.startDate))"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval != 0 ? timeInterval : 1, repeats: false)

        let request = UNNotificationRequest(identifier: event.id, content: content, trigger: trigger)

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            } else {
                print("Event notification scheduled successfully. \(timeInterval)")
            }
        }
    }

    func requestNotificationAuthorization() async -> Bool {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            return granted
        } catch {
            return false
        }
    }

    func removeAllNotificationsWithIdentifiers(identifiers: [String]) {
        center.removeDeliveredNotifications(withIdentifiers: identifiers)
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
