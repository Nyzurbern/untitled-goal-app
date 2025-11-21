//
//  Goal.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Combine
import Foundation

class GoalViewModel: ObservableObject {
    @Published var goal: Goal

    init(goal: Goal) {
        self.goal = goal
    }
}

struct Subgoal: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var coinReward: Int = 10
}

struct Goal: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var description: String
    var deadline: Date
    var subgoals: [Subgoal] = []
    var isCompleted: Bool = false
    var reflections: [String] = []
    var character: Character
    var coins: Int
    var progress: Double {
        guard !subgoals.isEmpty else { return 0.0 }
        let done = subgoals.filter { $0.isCompleted }.count
        return Double(done) / Double(subgoals.count)
    }
    var foodprogressbar: Double = 30
    var drinksprogressbar: Double = 30
    var characterName: String = ""
    var challenges: String = ""
    var actionsorhabits: String = ""
    var resourcesorsupport: String = ""
}

struct Character: Identifiable, Hashable, Codable {
    var id = UUID()
    var profileImage: String
    var image: String
    var waterLevel: Int
    var foodLevel: Int
}

struct Consumable: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var dftype: String
    var image: String
    var cost: Int
    var fillAmount: Int
}
