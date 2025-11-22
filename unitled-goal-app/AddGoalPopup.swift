//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

private extension String {
    var isTrimmedEmpty: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddGoalPopupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userData: UserData
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var GoalDeadline: Date = Date()
    @State private var CharacterName: String = ""
    @State private var image: String = ""
    @State private var profileImage: String = ""
    @State private var CharacterPicked: Int = 0
    
    // True only when all required fields are non-empty after trimming
    private var allRequiredFieldsFilled: Bool {
        !title.isTrimmedEmpty &&
        !description.isTrimmedEmpty &&
        !CharacterName.isTrimmedEmpty &&
        !image.isTrimmedEmpty &&
        !profileImage.isTrimmedEmpty
    }
    
    let characterOptions = [
        ("Male Icon", "Male"),
        ("Female Icon", "Female"),
        ("Female Star Icon", "Female Star")
    ]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    TextField("Short description", text: $description)
                        .textInputAutocapitalization(.sentences)
                    DatePicker("Deadline", selection: $GoalDeadline, displayedComponents: .date)
                    TextField("Character name", text: $CharacterName)
                        .textInputAutocapitalization(.sentences)
                }
                Section(header: Text("Character")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(characterOptions.enumerated()), id: \.offset) { index, character in
                                Button {
                                    profileImage = character.0
                                    image = character.1
                                    CharacterPicked = index + 1
                                } label: {
                                    Image(character.0)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 80, height: 80)
                                        .clipShape(Circle())
                                        .overlay {
                                            if CharacterPicked == index + 1 {
                                                Circle().stroke(.blue, lineWidth: 4)
                                            }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let g = Goal(
                            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
                            deadline: GoalDeadline,
                            subgoals: [],
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
                        userData.goals.append(g)
                        dismiss()
                        // Schedule notifications for the goal
                        NotificationManager.shared.scheduleGoalNotifications(for: g)
                    }
                    .disabled(!allRequiredFieldsFilled)
                }
            }
        }
    }
}

