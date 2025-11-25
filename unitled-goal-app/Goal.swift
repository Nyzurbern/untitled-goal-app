//
//  Goal.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import Combine
import Foundation
import SwiftData
import SwiftUI

class GoalViewModel: ObservableObject {
    @Published var goal: Goal
    init(goal: Goal) { self.goal = goal }
}

struct Subgoal: Identifiable, Hashable, Codable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var coinReward: Int = 10
    var deadline: Date = Date()  // Needed for notification scheduling
}

@Model class Goal: Identifiable, Equatable {
    var id = UUID()
    var title: String
    var desc: String
    var deadline: Date
    var subgoals: [Subgoal] = []
    var isCompleted: Bool = false
    var reflections: [String] = []
    var character: Character
    var coins: Int
    var failed: Bool = false
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
    var sortIndex: Int

    // Derived from persisted subgoals, so it always matches and persists indirectly.
    var subgoalscompleted: Int {
        subgoals.filter { $0.isCompleted }.count
    }

    init(
        id: UUID = UUID(),
        title: String,
        desc: String,
        deadline: Date,
        subgoals: [Subgoal] = [],
        isCompleted: Bool = false,
        reflections: [String] = [],
        character: Character,
        coins: Int = 0,
        failed: Bool = false,
        foodprogressbar: Double = 30,
        drinksprogressbar: Double = 30,
        characterName: String = "",
        challenges: String = "",
        actionsorhabits: String = "",
        resourcesorsupport: String = "",
        sortIndex: Int = 0
    ) {
        self.id = id
        self.title = title
        self.desc = desc
        self.deadline = deadline
        self.subgoals = subgoals
        self.isCompleted = isCompleted
        self.reflections = reflections
        self.character = character
        self.coins = coins
        self.failed = failed
        self.foodprogressbar = foodprogressbar
        self.drinksprogressbar = drinksprogressbar
        self.characterName = characterName
        self.challenges = challenges
        self.actionsorhabits = actionsorhabits
        self.resourcesorsupport = resourcesorsupport
        self.sortIndex = sortIndex
    }
}

struct Character: Identifiable, Hashable, Codable {
    var id = UUID()
    var profileImage: String
    var image: String
    var waterLevel: Int
    var foodLevel: Int
    enum CodingKeys: String, CodingKey {
        case id, profileImage, image, waterLevel, foodLevel
    }

    init(
        id: UUID = UUID(),
        profileImage: String,
        image: String,
        waterLevel: Int,
        foodLevel: Int
    ) {
        self.id = id
        self.profileImage = profileImage
        self.image = image
        self.waterLevel = waterLevel
        self.foodLevel = foodLevel
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(profileImage, forKey: .profileImage)
        try container.encode(image, forKey: .image)
        try container.encode(waterLevel, forKey: .waterLevel)
        try container.encode(foodLevel, forKey: .foodLevel)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        profileImage = try container.decode(String.self, forKey: .profileImage)
        image = try container.decode(String.self, forKey: .image)
        waterLevel = try container.decode(Int.self, forKey: .waterLevel)
        foodLevel = try container.decode(Int.self, forKey: .foodLevel)
    }
}

struct Consumable: Identifiable, Hashable, Codable {
    var id = UUID()
    var name: String
    var dftype: String
    var image: String
    var cost: Int
    var fillAmount: Int
}

