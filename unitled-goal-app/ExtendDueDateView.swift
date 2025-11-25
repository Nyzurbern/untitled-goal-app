//
//  ExtendDueDateView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//
import SwiftUI
import SwiftData

struct ExtendDueDateView: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.dismiss) private var dismiss
    @Bindable var goal: Goal

    @State private var newDate: Date

    init(goal: Goal) {
        self.goal = goal
        _newDate = State(initialValue: goal.deadline)
    }

    private var minimumDate: Date {
        max(Date(), goal.deadline)
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
                        goal.deadline = newDate
                        dismiss()
                    }
                    .bold()
                }
            }
        }
    }
}
