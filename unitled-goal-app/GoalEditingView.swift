//
//  GoalEditingView.swift
//  unitled-goal-app
//
//  Created by T Krobot on 22/11/25.
//

import SwiftUI

struct GoalEditingView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var goal: Goal
    @State private var CharacterPicked: Int
    let characterOptions = [
        ("Male Icon", "Male"),
        ("Female Icon", "Female"),
        ("Female Star Icon", "Female Star")
    ]
    
    init(goal: Goal) {
        self._goal = Bindable(wrappedValue: goal)
 
        let index = characterOptions.firstIndex { option in
            option.1 == goal.character.image
        } ?? -1
    
        self._CharacterPicked = State(initialValue: index >= 0 ? index + 1 : 0)
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section(header: Text("Title")) {
                    TextField("Title", text: $goal.title)
                        .textInputAutocapitalization(.sentences)
                }
                Section(header: Text("Short Description")) {
                    TextField("Short description", text: $goal.desc)
                        .textInputAutocapitalization(.sentences)
                }
                //change this part
                Section(header: Text("Deadline")) {
                    DatePicker("Deadline", selection: $goal.deadline, displayedComponents: .date)
                }
                Section(header: Text("Character Name")) {
                    TextField("Character name", text: $goal.characterName)
                        .textInputAutocapitalization(.sentences)
                }
                
                Section(header: Text("Character")) {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(characterOptions.enumerated()), id: \.offset) { index, character in
                                Button {
                                    goal.character.profileImage = character.0
                                    goal.character.image = character.1
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
            .navigationTitle("Edit Goal")
            .toolbar{
                ToolbarItem{
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        
    }
}
//
//#Preview {
//    GoalEditingView()
//}
