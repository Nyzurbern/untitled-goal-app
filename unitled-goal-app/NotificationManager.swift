//
//  NotificationManager.swift
//  unitled-goal-app
//
//  Created by Anish Das on 22/11/25.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    /// Request user permission to send notifications
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification authorization error: \(error.localizedDescription)")
            } else {
                print("Notification authorization granted: \(granted)")
            }
        }
    }

    /// Schedule notifications for a goal and all its subgoals
    func scheduleGoalNotifications(for goal: Goal) {
        removeNotifications(for: goal)

        // Notify goal 1 day before deadline
        if let goalAlertDate = Calendar.current.date(byAdding: .day, value: -1, to: goal.deadline) {
            scheduleNotification(
                id: "goal-\(goal.id.uuidString)",
                title: "Goal due soon!",
                body: "Your goal \"\(goal.title)\" is due tomorrow!",
                date: goalAlertDate
            )
        }

        // Notify each subgoal on its deadline
        for subgoal in goal.subgoals {
            scheduleNotification(
                id: "subgoal-\(subgoal.id.uuidString)",
                title: "Subgoal due today!",
                body: "Your subgoal \"\(subgoal.title)\" is due today!",
                date: subgoal.deadline
            )
        }
    }

    /// Remove all scheduled notifications for a goal and its subgoals
    func removeNotifications(for goal: Goal) {
        var ids: [String] = ["goal-\(goal.id.uuidString)"]
        let subgoalIDs = goal.subgoals.map { "subgoal-\($0.id.uuidString)" }
        ids.append(contentsOf: subgoalIDs)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }

    /// Schedule a single notification
    private func scheduleNotification(id: String, title: String, body: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.badge = 1

        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Scheduled notification \(id) for \(date)")
            }
        }
    }
}
