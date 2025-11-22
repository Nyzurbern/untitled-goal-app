//
//  DueDatePopupView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//

import SwiftUI
import SwiftData

struct DueDatePopupView: View {
    @EnvironmentObject var userData: UserData
//    @ObservedObject var ViewModel: GoalViewModel
    @State private var ExtendDueDate = false
    @State private var isShowingReflectionSheet = false
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @Query var goals: [Goal]
    @Bindable var goal: Goal

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text(goal.title)
                    .font(.title)
                Text("IS DUE!")
                    .font(.title)
                    .foregroundStyle(.red)
                Text("What's the status of this goal?")
                    .font(.title2)
                NavigationLink {
                    ReflectionSheetView(
                        isShowingReflectionSheet: $isShowingReflectionSheet,
                        isFailed: true,
                        goal: goal,
                        archiveGoal: { archiveGoal(isFailed: true) }
                    )
                } label: {
                    Text("I didn't manage to do it..")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(Color.red)
                        )
                        .foregroundStyle(.white)
                }

                NavigationLink {
                    ExtendDueDateView(goal: goal)
                } label: {
                    Text("I need more time!")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(
                                Color.yellow
                            )
                        )
                        .foregroundStyle(.white)

                }
                NavigationLink {
                    ReflectionSheetView(
                        isShowingReflectionSheet: $isShowingReflectionSheet,
                        isFailed: false,
                        goal: goal,
                        archiveGoal: { archiveGoal(isFailed: false) }
                    )
                } label: {
                    Text("I completed my goal!!!!")
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(Color.green)
                        )
                        .foregroundStyle(.white)
                }

                .navigationTitle("Goal Status")
            }
        }

    }
    private func archiveGoal(isFailed: Bool) {
        print("Archive button tapped for goal: \(goal.title)")

        goal.isCompleted = true
        if isFailed {
            goal.failed = true
        }
        
        userData.dueGoal = nil

        dismiss()
    }
}
