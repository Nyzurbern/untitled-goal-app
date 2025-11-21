//
//  DueDatePopupView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 15/11/25.
//

import SwiftUI

struct DueDatePopupView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var ViewModel: GoalViewModel
    @State private var ExtendDueDate = false
    @State private var isShowingReflectionSheet = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text(ViewModel.goal.title)
                    .font(.title)
                Text("IS DUE!")
                    .font(.title)
                    .foregroundStyle(.red)
                Text("What's the status of this goal?")
                    .font(.title2)
                NavigationLink {
                    ReflectionSheetView(
                        ViewModel: GoalViewModel(goal: ViewModel.goal),
                        isShowingReflectionSheet: $isShowingReflectionSheet,
                        archiveGoal: archiveGoal
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
                    ExtendDueDateView(ViewModel: ViewModel)
                } label: {
                    Text("Let me extend the date papi!")
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
                        ViewModel: GoalViewModel(goal: ViewModel.goal),
                        isShowingReflectionSheet: $isShowingReflectionSheet,
                        archiveGoal: archiveGoal
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

                .navigationTitle("")
            }
        }

    }
    private func archiveGoal() {
        print("Archive button tapped for goal: \(ViewModel.goal.title)")

        ViewModel.goal.isCompleted = true
        if let index = userData.goals.firstIndex(where: {
            $0.id == ViewModel.goal.id
        }) {
            userData.goals[index] = ViewModel.goal
        }

        dismiss()
    }
}
