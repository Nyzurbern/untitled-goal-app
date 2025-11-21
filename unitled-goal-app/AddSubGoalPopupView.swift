//
//  AddSubGoalPopupView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct AddSubGoalPopupView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) var dismiss
    
    @Binding var goal: Goal
    @State private var title: String = ""
    @State private var reward: Int = 10
    @State var SubGoalDeadline:Date = Date()
    var body: some View {
        NavigationStack {
            Form {
                if userData.goals.isEmpty {
                    Text("Add a goal first to attach sub-goals.")
                        .foregroundColor(.secondary)
                } else {
                    
                    Section{
                        TextField("Title", text: $title)
                        Text("Reward: \(reward) coins")
                        DatePicker("Deadline", selection: $SubGoalDeadline, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Add Sub-goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !userData.goals.isEmpty else { return }
                        let s = Subgoal(title: title, coinReward: reward)
                        goal.subgoals.append(s)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || userData.goals.isEmpty)
                }
            }
        }
    }
}
//#Preview {
//    AddSubGoalPopupView(goal: Goa)
//        .environmentObject(UserData(sample: true))
//}
