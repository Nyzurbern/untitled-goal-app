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
    @ObservedObject var ViewModel: GoalViewModel
    @State private var title = ""
    @State private var reward = 10
    @State private var SubGoalDeadline = Date()

    var body: some View {
        NavigationStack {
            Form {
                if userData.goals.isEmpty {
                    Text("Add a goal first to attach sub-goals.").foregroundColor(.secondary)
                } else {
                    Section {
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
                        let s = Subgoal(title: title, coinReward: reward, deadline: SubGoalDeadline)
                        ViewModel.goal.subgoals.append(s)
                        NotificationManager.shared.scheduleGoalNotifications(for: ViewModel.goal)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || userData.goals.isEmpty)
                }
            }
        }
    }
}
