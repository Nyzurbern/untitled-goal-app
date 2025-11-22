//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddGoalPopupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userData: UserData

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var GoalDeadline: Date = Date()
    @State private var CharacterName: String = ""
    @State private var profileImage: String = "Subject 3"
    @State private var image: String = "subject nobody"
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Goal Title", text: $title)
                .textFieldStyle(.roundedBorder)
            TextField("Description", text: $description)
                .textFieldStyle(.roundedBorder)
            DatePicker("Deadline", selection: $GoalDeadline, displayedComponents: [.date])
            TextField("Character Name", text: $CharacterName)
                .textFieldStyle(.roundedBorder)
            
            Button("Add Goal") {
                let newGoal = Goal(
                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                    description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                    deadline: GoalDeadline,
                    subgoals: [], // Start empty; user can add subgoals later
                    reflections: [],
                    character: Character(
                        profileImage: profileImage,
                        image: image,
                        waterLevel: 30,
                        foodLevel: 30
                    ),
                    coins: 50,
                    foodprogressbar: 30,
                    drinksprogressbar: 30,
                    characterName: CharacterName.trimmingCharacters(in: .whitespacesAndNewlines)
                )

                // Append goal to UserData
                userData.goals.append(newGoal)
                
                // Schedule notifications for the goal
                NotificationManager.shared.scheduleGoalNotifications(for: newGoal)
                
                // Close the popup
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 16)
        }
        .padding()
    }
}
