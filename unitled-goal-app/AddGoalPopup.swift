//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftData
import SwiftUI

extension String {
    fileprivate var isTrimmedEmpty: Bool {
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct AddGoalPopupView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var userData: UserData
    @Environment(\.modelContext) var modelContext
    @Query var goals: [Goal]

    @State private var title: String = ""
    @State private var description: String = ""
    @State private var GoalDeadline: Date = Date()
    @State private var CharacterName: String = ""
    @State private var image: String = ""
    @State private var profileImage: String = ""
    @State private var CharacterPicked: Int = 0
    private var allRequiredFieldsFilled: Bool {
        !title.isTrimmedEmpty && !description.isTrimmedEmpty
            && !CharacterName.isTrimmedEmpty && !image.isTrimmedEmpty
            && !profileImage.isTrimmedEmpty
    }

    let characterOptions = [
        ("Male Icon", "Male"),
        ("Female Icon", "Female"),
        ("Female Star Icon", "Female Star"),
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Goal Details")) {
                    TextField("Title", text: $title)
                        .textInputAutocapitalization(.sentences)
                    TextField("Short description", text: $description)
                        .textInputAutocapitalization(.sentences)
                    DatePicker(
                        "Deadline",
                        selection: $GoalDeadline,
                        displayedComponents: .date
                    )
                }
                Section(header: Text("Character")) {
                    ScrollView(.horizontal) {
                        
                        TextField("Character name", text: $CharacterName)
                            .textInputAutocapitalization(.sentences)
                        
                        HStack {
                            ForEach(
                                Array(characterOptions.enumerated()),
                                id: \.offset
                            ) { index, character in
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
                                                Circle().stroke(
                                                    .blue,
                                                    lineWidth: 4
                                                )
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
                            title: title.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            desc: description.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            deadline: GoalDeadline,
                            subgoals: [],
                            isCompleted: false,
                            reflections: [],
                            character: Character(
                                profileImage: profileImage,
                                image: image,
                                waterLevel: 30,
                                foodLevel: 30
                            ),
                            coins: 50,
                            failed: false,
                            foodprogressbar: 30,
                            drinksprogressbar: 30,
                            characterName: CharacterName.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ),
                            challenges: "",
                            actionsorhabits: "",
                            resourcesorsupport: "",
                            sortIndex: (goals.max(by: {
                                $0.sortIndex < $1.sortIndex
                            })?.sortIndex ?? 0) + 1
                        )
                        modelContext.insert(g)
                        dismiss()
                        // Schedule notifications for the goal
                        NotificationManager.shared.scheduleGoalNotifications(
                            for: g
                        )
                    }
                    .disabled(!allRequiredFieldsFilled)
                }
            }
        }
    }
}
