//
//  HomeView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI
import SwiftData

// HomeView.swift
struct HomeView: View {
    @EnvironmentObject var userData: UserData
    @State private var showAddGoal = false
    @State private var showAddSubGoal = false
    @State private var editingGoal = false
    @State private var selectedGoalForEditing: Goal?
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Goal.sortIndex) var goals: [Goal]

    var activeGoals: [Goal] {
        goals.filter { !$0.isCompleted }
    }

    var body: some View {
        NavigationStack {

            VStack(alignment: .leading, spacing: 12) {
                
                if goals.filter ({!$0.isCompleted }).isEmpty {
                    ContentUnavailableView("No goals", systemImage: "list.bullet", description: Text("You have no goals yet."))
                } else {
                    
                    List {
                        ForEach(
                            goals.filter {
                                !$0.isCompleted
                            }
                        ) { goal in
                            
                            Section {
                                NavigationLink {
                                    BigGoalCharacterView(goal: goal)
                                } label: {
                                    GoalCardView(goal: goal)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        modelContext.delete(goal)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    Button{
                                        selectedGoalForEditing = goal
                                    } label: {
                                        Label("Edit", systemImage: "pencil")
                                    }
                                }
                            }
                        } .onDelete { indexSet in
                            indexSet.forEach{ index in
                                modelContext.delete(activeGoals[index])
                            }
                        }
                    }
                    .listStyle(.automatic)
                }
            }
    
            .toolbar{
                EditButton()
                Button {
                    showAddGoal = true
                } label: {
                    Image(
                        systemName: "plus"
                    )
                }
            }
            .navigationTitle("My Goals")
            .lineSpacing(50)
            .sheet(isPresented: $showAddGoal) {
                AddGoalPopupView()
                    .environmentObject(userData)
            }
            .sheet(item: $selectedGoalForEditing) { goal in
                GoalEditingView(goal: goal)
            }
            .sheet(item: $userData.dueGoal) { due in
                DueDatePopupView(goal: due)
                    .environmentObject(userData)
                    .interactiveDismissDisabled()
            }
            .onAppear {
                userData.checkDailyDecrease(goals: goals)
                userData.checkForDueGoals(goals: goals)
            }
            .onReceive(NotificationCenter.default.publisher(for: .userDataTick)) { _ in
                userData.checkDailyDecrease(goals: goals)
                userData.checkForDueGoals(goals: goals)
            }
            .onChange(of: goals) {
                userData.checkDailyDecrease(goals: goals)
                userData.checkForDueGoals(goals: goals)
            }
        }
    }
}
