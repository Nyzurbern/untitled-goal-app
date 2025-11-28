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

                    Text("Your goal")
                    .font(.title3)
                    Text(goal.title)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(" is DUE!")
                    .font(.title3)
                        
                NavigationLink {
                    ReflectionSheetView(
                        isShowingReflectionSheet: $isShowingReflectionSheet,
                        isFailed: true,
                        goal: goal,
                        archiveGoal: { archiveGoal(isFailed: true) }
                    )
                } label: {
                    Text("I didn't manage to do it..")
                        .frame(maxWidth: 200)
                        .padding(14)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(Color.red)
                        )

                }

                NavigationLink {
                    ExtendDueDateView(goal: goal)
                } label: {
                    Text("I need more time!")
                        .padding(14)
                        .frame(maxWidth: 230)
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
                        .frame(maxWidth: 200)
                        .padding(14)
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
