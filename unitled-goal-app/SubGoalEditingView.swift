//
//  SubEditingGoalView.swift
//  unitled-goal-app
//
//  Created by T Krobot on 22/11/25.
//

import SwiftData
import SwiftUI

struct SubGoalEditingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var subgoal: Subgoal
    @Bindable var goal: Goal

    private var dateRange: ClosedRange<Date> {
        let maxDate: Date =
            Calendar.current.date(byAdding: .day, value: 1, to: goal.deadline)
            ?? goal.deadline
        return Date.now...maxDate
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $subgoal.title)
                    Text("Reward: \(subgoal.coinReward) coins")
                    DatePicker(
                        "Deadline",
                        selection: $subgoal.deadline,
                        in: dateRange,
                        displayedComponents: .date
                    )
                }
            }
            .navigationTitle("Edit Subgoal")
            .toolbar {
                ToolbarItem {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
