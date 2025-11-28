//
//  AddSubGoalPopupView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI
import SwiftData

struct AddSubGoalPopupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var SubGoalDeadline = Date()
    @State private var reward = 10
    @Query var goals: [Goal]
    @Bindable var goal: Goal
    var body: some View {
        let maxDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: goal.deadline) ?? goal.deadline
        let dateRange: ClosedRange<Date> = Date.now...maxDate

        NavigationStack {
            Form {
                if goals.isEmpty {
                    Text("Add a goal first to attach subgoals.").foregroundColor(.secondary)
                } else {
                    Section {
                        TextField("Title", text: $title)
                        DatePicker("Deadline", selection: $SubGoalDeadline, in: dateRange, displayedComponents: .date)
                        Text("Reward: \(reward) coins")
                    }
                }
            }
            .navigationTitle("Add Subgoal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !goals.isEmpty else { return }
                        let s = Subgoal(title: title, isCompleted: false, deadline: SubGoalDeadline, coinReward: reward)
                        goal.subgoals.append(s)
                        NotificationManager.shared.scheduleGoalNotifications(for: goal)
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty || goals.isEmpty)
                }
            }
        }
    }
}
