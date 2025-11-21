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
                // Header + summary
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("My Goals")
                            .font(.largeTitle)
                            .bold()
                    }
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)

                // actions
                HStack(spacing: 12) {
                    Button {
                        showAddGoal = true
                    } label: {
                        Label("Add Goal", systemImage: "plus.circle.fill")
                            .padding(.vertical, 10)
                            .padding(.horizontal, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 10).fill(
                                    Color.blue
                                )
                            )
                            .foregroundStyle(.white)
                    }

                    Spacer()
                }
                .padding(.horizontal)
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(
                            $userData.goals.filter {
                                !$0.wrappedValue.isCompleted
                            }
                        ) { $goal in
                            NavigationLink {
                                BigGoalCharacterView(
                                    ViewModel: GoalViewModel(goal: goal),
                                    goal: $goal
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
        }
    }
}
