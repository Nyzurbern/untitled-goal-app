//
//  SubEditingGoalView.swift
//  unitled-goal-app
//
//  Created by T Krobot on 22/11/25.
//

import SwiftUI

struct SubGoalEditingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var subgoal: Subgoal
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $subgoal.title)
                    Text("Reward: \(10) coins")
                    DatePicker("Deadline", selection: $subgoal.deadline, displayedComponents: .date)
                }
            }
            .navigationTitle("Edit Subgoal")
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
