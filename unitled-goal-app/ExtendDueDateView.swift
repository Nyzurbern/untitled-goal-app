//
//  ExtendDueDateView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//

import SwiftUI

struct ExtendDueDateView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var ViewModel: GoalViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var newDate: Date

    init(ViewModel: GoalViewModel) {
        self.ViewModel = ViewModel
        _newDate = State(initialValue: ViewModel.goal.deadline)
    }

    private var minimumDate: Date {

        max(Date(), ViewModel.goal.deadline)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Pick a new due date") {
                    DatePicker(
                        "New due date",
                        selection: $newDate,
                        in: minimumDate...,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Extend Due Date")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        userData.dueGoal = nil
                        save()
                    }
                        .bold()
                }
            }
        }
    }

    private func save() {
        if let index = userData.goals.firstIndex(where: {
            $0.id == ViewModel.goal.id
        }) {
            var updatedGoal = userData.goals[index]
            
            updatedGoal.deadline = newDate
            
            userData.goals[index] = updatedGoal
            
            ViewModel.goal = updatedGoal
            
            userData.dueGoal = nil
            NotificationManager.shared.scheduleGoalNotifications(for: updatedGoal)
        }

        dismiss()
    }
}
