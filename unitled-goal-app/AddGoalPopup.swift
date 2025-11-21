//
//  AddGoalPopup.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddGoalPopupView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var GoalDeadline: Date = Date()
    @State private var reward: Int = 50
    @State private var image: String = "subject nobody"
    @State private var profileImage: String = "Subject 3"
    @State private var CharacterPicked: Int = 0
    @State private var CharacterName: String = ""
    
    let characterOptions = [
        ("Subject 3", "subject nobody"),
        ("Subject 4", "subject nobody") // Add your actual image names here
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
                
                Section(header: Text("Reward")) {
                    Text("Coin reward: \(reward)")
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
                            title: title,
                            description: description,
                            deadline: GoalDeadline,
                            subgoals: [],
                            reflections: [],
                            character: Character(
                                profileImage: profileImage,
                                image: image,
                                waterLevel: 30,
                                foodLevel: 30
                            ),
                            coins: reward, // Fixed: use reward instead of hardcoded 10
                            foodprogressbar: 30,
                            drinksprogressbar: 30,
                            characterName: CharacterName
                        )
                        userData.goals.append(g)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
#Preview {
    AddGoalPopupView()
        .environmentObject(UserData(sample: true))
}
