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
    @State private var reward = 10
    @State private var SubGoalDeadline = Date()
    @Query var goals: [Goal]
    @Bindable var goal: Goal
    var body: some View {
        let maxDate: Date = Calendar.current.date(byAdding: .day, value: 1, to: goal.deadline) ?? goal.deadline
        let dateRange: ClosedRange<Date> = Date.now...maxDate

        NavigationStack {
            Form {
                if goals.isEmpty {
                    Text("Add a goal first to attach sub-goals.").foregroundColor(.secondary)
                } else {
                    Section {
                        TextField("Title", text: $title)
                        Text("Reward: \(reward) coins")
                        DatePicker("Deadline", selection: $SubGoalDeadline, in: dateRange, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("Add Sub-goal")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard !goals.isEmpty else { return }
                        let s = Subgoal(title: title, isCompleted: false, coinReward: reward, deadline: SubGoalDeadline)
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
