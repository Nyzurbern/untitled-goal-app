//
//  UserData.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Foundation
import Combine
import CoreGraphics

final class UserData: ObservableObject {
    @Published var goals: [Goal] = [] {
        didSet {
            saveGoals()
        }
    }
    
    private let saveKey = "SavedGoals"
    private var timer: Timer?
    private let lastDecreaseDateKey = "LastDecreaseDate"
    
    init(sample: Bool = false) {
        if sample {
            goals = [
                Goal(
                    title: "Write Essay",
                    description: "Finish the 1500-word essay on climate.",
                    deadline: Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date(),
                    subgoals: [
                        Subgoal(title: "Outline", coinReward: 10),
                        Subgoal(title: "Draft", coinReward: 20),
                        Subgoal(title: "Proofread", coinReward: 10)
                    ],
                    reflections: ["Start early next time"],
                    character: Character(profileImage: "Subject 3", image: "subject nobody", waterLevel: 30, foodLevel: 30),
                    coins: 10,
                    foodprogressbar: 30,
                    drinksprogressbar: 30
                )
            ]
        } else {
            loadGoals()
        }
        
        startDailyDecreaseTimer()
        checkDailyDecrease()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startDailyDecreaseTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 360, repeats: true) { _ in
            self.checkDailyDecrease()
        }
    }
    
    private func checkDailyDecrease() {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let lastDecreaseDate = UserDefaults.standard.object(forKey: lastDecreaseDateKey) as? Date ?? currentDate
        if !calendar.isDate(lastDecreaseDate, inSameDayAs: currentDate) {
            decreaseBarsForNewDay()
            UserDefaults.standard.set(currentDate, forKey: lastDecreaseDateKey)
        }
    }
    
    private func decreaseBarsForNewDay() {
        for index in goals.indices {
            goals[index].foodprogressbar = max(0, goals[index].foodprogressbar - 5)
            
            goals[index].drinksprogressbar = max(0, goals[index].drinksprogressbar - 5)
        }
        
        print("Daily decrease applied - Food: -5, Water: -5") // For debugging
    }
    
    private func saveGoals() {
        if let encoded = try? JSONEncoder().encode(goals) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
            print("Saved \(goals.count) goals")
        }
    }
    
    private func loadGoals() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([Goal].self, from: data) {
            goals = decoded
            print("Loaded \(goals.count) goals")
        }
    }
}
