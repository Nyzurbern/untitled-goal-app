//
//  UserData.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

final class UserData: ObservableObject {
    @Published var dueGoal: Goal? = nil

    private var timer: Timer?
    private let lastDecreaseDateKey = "LastDecreaseDate"

    init() {
        startDailyTimer()
    }

    deinit {
        timer?.invalidate()
    }

    private func startDailyTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 360, repeats: true) { [weak self] _ in
            guard self != nil else { return }
            NotificationCenter.default.post(name: .userDataTick, object: nil)
        }
    }

    func checkDailyDecrease(goals: [Goal]) {
        let currentDate = Date()
        let calendar = Calendar.current

        let lastDecreaseDate = UserDefaults.standard.object(forKey: lastDecreaseDateKey) as? Date ?? currentDate
        if !calendar.isDate(lastDecreaseDate, inSameDayAs: currentDate) {
            decreaseBarsForNewDay(goals: goals)
            UserDefaults.standard.set(currentDate, forKey: lastDecreaseDateKey)
        }
    }

    private func decreaseBarsForNewDay(goals: [Goal]) {
        for goal in goals {
            goal.foodprogressbar = max(0, goal.foodprogressbar - 5)
            goal.drinksprogressbar = max(0, goal.drinksprogressbar - 5)
        }
        print("Daily decrease applied - Food: -5, Water: -5")
    }

    func checkForDueGoals(goals: [Goal]) {
        let calendar = Calendar.current
        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday)!

        var found: Goal? = nil
        for goal in goals where !goal.isCompleted {
            let deadline = goal.deadline
            let isToday = deadline >= startOfToday && deadline < startOfTomorrow
            let isPast = deadline < startOfToday
            if (isToday || isPast) {
                found = goal
                break
            }
        }
        
        if dueGoal?.id != found?.id {
            dueGoal = found
        }
    }
}

extension Notification.Name {
    static let userDataTick = Notification.Name("UserDataTick")
}

