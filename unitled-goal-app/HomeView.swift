//
//  HomeView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

// HomeView.swift
struct HomeView: View {
    @EnvironmentObject var userData: UserData
    @State private var showAddGoal = false
    @State private var showAddSubGoal = false

    var activeGoals: [Goal] {
        userData.goals.filter { !$0.isCompleted }
    }

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {

                    Text("My goals")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button {
                        showAddGoal = true
                    } label: {
                        Image(
                            systemName: "plus.circle.fill"
                        )
                        .padding(.vertical, 10)
                        .padding(.horizontal, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 10).fill(
                                Color.blue
                            )
                        )
                        .foregroundStyle(.white)
                    }

                }
                .padding(.horizontal)
                .padding(.top)

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(
                            $userData.goals.filter {
                                !$0.wrappedValue.isCompleted
                            }
                        ) { $goal in
                            NavigationLink {
                                BigGoalCharacterView(
                                    ViewModel: GoalViewModel(goal: goal)
                                )
                            } label: {
                                GoalCardView(goal: goal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .sheet(isPresented: $showAddGoal) {
                AddGoalPopupView()
                    .environmentObject(userData)
            }
            .sheet(item: $userData.dueGoal) { due in
                DueDatePopupView(ViewModel: GoalViewModel(goal: due))
                    .environmentObject(userData)
                    .interactiveDismissDisabled()
            }
        }
    }
}
