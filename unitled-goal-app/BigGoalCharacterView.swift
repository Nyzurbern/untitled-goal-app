//
//  BigGoalCharacterView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI
import SwiftData

struct BigGoalCharacterView: View {
    @State private var isShowingReflectionSheet = false
    @Environment(\.dismiss) private var dismiss
    @Bindable var goal: Goal
    @State private var selectedSubgoalID: Subgoal.ID?
    
    // Use a computed property so we don't reference ViewModel before init
    private var foodProgress: CGFloat {
        CGFloat(goal.foodprogressbar) / 250.0
    }
    
    private var drinkProgress: CGFloat {
        CGFloat(goal.drinksprogressbar) / 250.0
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    VStack{
                        Text(
                            "Hi! My name is \(goal.characterName)"
                        )
                        .font(.title)
                        
                        Spacer()
                    }
                    
                    if goal.foodprogressbar <= 10 {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Your character is hungry!")
                                .font(.caption)
                                .bold()
                        }
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    if goal.drinksprogressbar <= 10 {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Your character is thirsty!")
                                .font(.caption)
                                .bold()
                        }
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    ZStack {
                        Image(goal.character.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 350, maxHeight: 350)
                        HStack {
                            NavigationLink {
                                FoodShopView(goal: goal)
                            } label: {
                                ZStack {
                                    if #available(iOS 26.0, *) {
                                        Text("🍴")
                                            .padding()
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 8)
                                            )
                                            .glassEffect()
                                            .font(.system(size: 36))
                                    } else {
                                        Text("🍴")
                                            .padding()
                                            .background(.blue)
                                            .foregroundStyle(.white)
                                            .font(.system(size: 36))
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 8)
                                            )
                                    }
                                    Circle()
                                        .stroke(lineWidth: 5)
                                        .opacity(0.5)
                                        .foregroundStyle(.gray)
                                        .frame(width: 50, height: 50)
                                    Circle()
                                        .trim(from: 0.0, to: min(foodProgress, 1.0)) // Trim based on computed progress
                                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)) // Style the line
                                        .foregroundColor(goal.foodprogressbar <= 10
                                                         ? Color.red : Color.orange)
                                        .frame(width: 70, height: 70)
                                }
                            }
                            Spacer()
                            NavigationLink {
                                DrinksShopView(goal: goal)
                            } label: {
                                ZStack {
                                    if #available(iOS 26.0, *) {
                                        Text("🧋")
                                            .padding()
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 8)
                                            )
                                            .glassEffect()
                                            .font(.system(size: 36))
                                    } else {
                                        Text("🧋")
                                            .padding()
                                            .background(.blue)
                                            .foregroundStyle(.white)
                                            .font(.system(size: 36))
                                            .clipShape(
                                                RoundedRectangle(cornerRadius: 8)
                                            )
                                    }
                                    Circle()
                                        .stroke(lineWidth: 5)
                                        .opacity(0.5)
                                        .foregroundStyle(.gray)
                                        .frame(width: 50, height: 50)
                                    Circle()
                                        .trim(from: 0.0, to: min(drinkProgress, 1.0)) // Trim based on computed progress
                                        .stroke(style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round)) // Style the line
                                        .foregroundColor(goal.drinksprogressbar <= 10
                                                         ? Color.red : Color.blue)
                                        .frame(width: 70, height: 70)
                                }
                            }
                        }
                    }
                    HStack {
                        Text("Due Date: ")
                            .bold()
                            .font(.title)
                        
                        Text(
                            goal.deadline,
                            format: .dateTime.day().month().year()
                        )
                        .bold()
                        .font(.title)
                    }
                    HStack {
                        Text(
                            "Food: \(Int(goal.foodprogressbar))/250"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                        Text(
                            "Water: \(Int(goal.drinksprogressbar))/250"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.06))
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Sub-goals")
                            .font(.title2.bold())
                        Spacer()
                        
                        NavigationLink {
                            AddSubGoalPopupView(goal: goal)
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
                    
                    if goal.subgoals.isEmpty {
                        Text("No subgoals yet. Add one to get started!")
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding()
                    } else {
                        List {
                            ForEach($goal.subgoals) { subgoal in
                                HStack {
                                    Button {
                                        subgoal.isCompleted.wrappedValue
                                            .toggle()
                                        if subgoal.isCompleted.wrappedValue {
                                            goal.coins +=
                                            subgoal.coinReward.wrappedValue
                                        } else {
                                            goal.coins -=
                                            subgoal.coinReward.wrappedValue
                                        }
                                    }
                                    .swipeActions(edge: .trailing) {
                                        Button(role: .destructive) {
                                                if let index = goal.subgoals.firstIndex(where: { $0.id == subgoal.id }) {
                                                    goal.subgoals.remove(at: index)
                                                }
                                            } label: {
                                                Label("Delete", systemImage: "trash")
                                            }
                                        Button{
                                            selectedSubgoalID = subgoal.id.wrappedValue
                                        } label: {
                                            Label("Edit", systemImage: "pencil")
                                        }
                                    }
                                    label: {
                                        Image(
                                            systemName: subgoal.isCompleted
                                                .wrappedValue
                                            ? "checkmark.circle.fill"
                                            : "circle"
                                        )
                                        .foregroundColor(
                                            subgoal.isCompleted.wrappedValue
                                            ? .green : .primary
                                        )
                                        .font(.title2)
                                    }
                                    
                                    TextField("Sub-goal", text: subgoal.title)
                                        .font(.body)
                                    
                                    Spacer()
                                    
                                    Text(
                                        "+\(subgoal.coinReward.wrappedValue) coins"
                                    )
                                    .font(.caption)
                                    .foregroundColor(.yellow)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color.yellow.opacity(0.2))
                                    .cornerRadius(4)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(
                            height: CGFloat(
                                goal.subgoals.count
                            ) * 70 + 20
                        )
                    }
                }
            }
        }
        .navigationTitle(goal.title)
        .sheet(isPresented: Binding(
            get: { selectedSubgoalID != nil },
            set: { if !$0 { selectedSubgoalID = nil } }
        )) {
            if let subgoalID = selectedSubgoalID,
               let index = goal.subgoals.firstIndex(where: { $0.id == subgoalID }) {
                SubGoalEditingView(subgoal: $goal.subgoals[index])
            } else {
                Text("Subgoal not found")
            }
        }
    }
    private func didDismiss() {
        print("dismissed")
    }
    
    //    private func archiveGoal() {
    //        goal.isCompleted = true
    //        if let index = userData.goals.firstIndex(where: {
    //            $0.id == goal.id
    //        }) {
    //            userData.goals[index] = goal
    //        }
    //        dismiss()
    //    }
}

