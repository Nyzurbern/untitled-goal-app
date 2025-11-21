//
//  BigGoalCharacterView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct BigGoalCharacterView: View {
    @EnvironmentObject var userData: UserData
    @ObservedObject var ViewModel: GoalViewModel
    @Binding var goal: Goal
    @State private var isShowingReflectionSheet = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        if goal.characterName != "" {
                            Text("Hi! My name is \(goal.characterName)")
                        }
                        Spacer()
                        
                        if goal.progress == 1.0 {
                            Button(action: {
                                isShowingReflectionSheet.toggle()
                            }) {
                                if #available(iOS 26.0, *) {
                                    Text("Reflect and archive")
                                        .padding()
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .glassEffect()
                                } else {
                                    Text("Reflect and archive")
                                        .padding()
                                        .background(.blue)
                                        .foregroundStyle(.white)
                                        .frame(height: 41.5)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                            .sheet(isPresented: $isShowingReflectionSheet, onDismiss: didDismiss) {
                                ReflectionSheetView(goal: $goal, isShowingReflectionSheet: $isShowingReflectionSheet, archiveGoal: archiveGoal)
                            }
                        }
                    }
                    
                    if goal.foodprogressbar <= 10 || goal.drinksprogressbar <= 10 {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .foregroundColor(.red)
                            Text("Your character is hungry/thirsty")
                                .font(.caption)
                                .bold()
                        }
                        .padding(8)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }

                    Image(goal.character.image)
                    Text(goal.deadline, format: .dateTime.day().month().year())
                        .bold()
                        .font(.title)
                    
                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 250, height: 40)
                                .foregroundStyle(.background)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                        .stroke(goal.foodprogressbar <= 10 ? Color.red : Color.orange, lineWidth: 3)
                                )
                            HStack {
                                Rectangle()
                                    .frame(width: goal.foodprogressbar, height: 40)
                                    .frame(maxWidth: 250, alignment: .leading)
                                    .foregroundStyle(goal.foodprogressbar <= 10 ? Color.red : Color.orange)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Text("🍞")
                        }

                        NavigationLink {
                            FoodShopView(goal: $goal)
                        } label: {
                            if #available(iOS 26.0, *) {
                                Text("Feed")
                                    .padding()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .glassEffect()
                            } else {
                                Text("Feed")
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .frame(height: 41.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }

                    HStack {
                        ZStack {
                            Rectangle()
                                .frame(width: 250, height: 40)
                                .foregroundStyle(.background)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                        .stroke(goal.drinksprogressbar <= 10 ? Color.red : Color.blue, lineWidth: 3)
                                )
                            HStack {
                                Rectangle()
                                    .frame(width: goal.drinksprogressbar, height: 40)
                                    .frame(maxWidth: 250, alignment: .leading)
                                    .foregroundStyle(goal.drinksprogressbar <= 10 ? Color.red : Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            Text("💧")
                        }

                        NavigationLink {
                            DrinksShopView(goal: $goal)
                        } label: {
                            if #available(iOS 26.0, *) {
                                Text("Drink")
                                    .padding()
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .glassEffect()
                            } else {
                                Text("Drink")
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .frame(height: 41.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    
                    HStack {
                        Text("Food: \(Int(goal.foodprogressbar))%/250")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("Water: \(Int(goal.drinksprogressbar))%/250")
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
                            AddSubGoalPopupView(goal: $goal)
                        } label: {
                            Text("Add Subgoal")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
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
                            ForEach($goal.subgoals) { $subgoal in
                                HStack {
                                    Button {
                                        $subgoal.isCompleted.wrappedValue.toggle()
                                        if subgoal.isCompleted {
                                            goal.coins += subgoal.coinReward
                                        } else {
                                            goal.coins -= subgoal.coinReward
                                        }
                                    } label: {
                                        Image(systemName: subgoal.isCompleted ? "checkmark.circle.fill" : "circle")
                                            .foregroundColor(subgoal.isCompleted ? .green : .primary)
                                            .font(.title2)
                                    }

                                    TextField("Sub-goal", text: $subgoal.title)
                                        .font(.body)

                                    Spacer()

                                    Text("+\(subgoal.coinReward) coins")
                                        .font(.caption)
                                        .foregroundColor(.yellow)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.yellow.opacity(0.2))
                                        .cornerRadius(4)
                                }
                                .padding(.vertical, 4)
                            }
                            .onDelete { indexSet in
                                goal.subgoals.remove(atOffsets: indexSet)
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(height: CGFloat(goal.subgoals.count) * 70 + 20)
                    }
                }
            }
        }
    }

    func didDismiss() {
       print("dismissed")
    }
    
    private func archiveGoal() {
        print("Archive button tapped for goal: \(goal.title)")
        
        goal.isCompleted = true
        if let index = userData.goals.firstIndex(where: { $0.id == goal.id }) {
            userData.goals[index] = goal
        }
        
        dismiss()
    }
}
