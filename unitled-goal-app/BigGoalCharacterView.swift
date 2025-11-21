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
    @State private var isShowingReflectionSheet = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        if ViewModel.goal.characterName != "" {
                            Text("Hi! My name is \(ViewModel.goal.characterName)")
                                .font(.title2)
                        }
                        Spacer()
                    }
                    
                    if ViewModel.goal.foodprogressbar <= 10 {
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
                    
                    if ViewModel.goal.drinksprogressbar <= 10 {
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
                    
                    Image(ViewModel.goal.character.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 350, maxHeight: 350)
                    
                    HStack {
                        Text("Due Date: ")
                            .bold()
                            .font(.title)
                        Text(ViewModel.goal.deadline, format: .dateTime.day().month().year())
                            .bold()
                            .font(.title)
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 250, height: 40)
                                    .foregroundStyle(.background)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                            .stroke(ViewModel.goal.foodprogressbar <= 10 ? Color.red : Color.orange, lineWidth: 3)
                                    )
                                HStack {
                                    Rectangle()
                                        .frame(width: ViewModel.goal.foodprogressbar, height: 40)
                                        .frame(maxWidth: 250, alignment: .leading)
                                        .foregroundStyle(ViewModel.goal.foodprogressbar <= 10 ? Color.red : Color.orange)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                Text("🍞")
                            }
                            
                            NavigationLink {
                                FoodShopView(ViewModel: ViewModel)
                            } label: {
                                Text("Feed")
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .frame(height: 41.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        HStack {
                            ZStack {
                                Rectangle()
                                    .frame(width: 250, height: 40)
                                    .foregroundStyle(.background)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
                                            .stroke(ViewModel.goal.drinksprogressbar <= 10 ? Color.red : Color.blue, lineWidth: 3)
                                    )
                                HStack {
                                    Rectangle()
                                        .frame(width: ViewModel.goal.drinksprogressbar, height: 40)
                                        .frame(maxWidth: 250, alignment: .leading)
                                        .foregroundStyle(ViewModel.goal.drinksprogressbar <= 10 ? Color.red : Color.blue)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                Text("💧")
                            }
                            
                            NavigationLink {
                                DrinksShopView(ViewModel: ViewModel)
                            } label: {
                                Text("Drink")
                                    .padding()
                                    .background(.blue)
                                    .foregroundStyle(.white)
                                    .frame(height: 41.5)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                        
                        HStack {
                            Text("Food: \(Int(ViewModel.goal.foodprogressbar))/250")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Text("Water: \(Int(ViewModel.goal.drinksprogressbar))/250")
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
                                AddSubGoalPopupView(ViewModel: ViewModel)
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
                        
                        if ViewModel.goal.subgoals.isEmpty {
                            Text("No subgoals yet. Add one to get started!")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding()
                        } else {
                            List {
                                ForEach($ViewModel.goal.subgoals) { subgoal in
                                    HStack {
                                        Button {
                                            subgoal.isCompleted.wrappedValue.toggle()
                                            if subgoal.isCompleted.wrappedValue {
                                                ViewModel.goal.coins += subgoal.coinReward.wrappedValue
                                            } else {
                                                ViewModel.goal.coins -= subgoal.coinReward.wrappedValue
                                            }
                                        } label: {
                                            Image(systemName: subgoal.isCompleted.wrappedValue ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(subgoal.isCompleted.wrappedValue ? .green : .primary)
                                                .font(.title2)
                                        }
                                        
                                        TextField("Sub-goal", text: subgoal.title)
                                            .font(.body)
                                        
                                        Spacer()
                                        
                                        Text("+\(subgoal.coinReward.wrappedValue) coins")
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
                                    ViewModel.goal.subgoals.remove(atOffsets: indexSet)
                                }
                            }
                            .listStyle(.plain)
                            .scrollContentBackground(.hidden)
                            .background(Color.clear)
                            .frame(height: CGFloat(ViewModel.goal.subgoals.count) * 70 + 20)
                        }
                    }
                }
            }
        }
    }
    
    private func didDismiss() {
        print("dismissed")
    }

    private func archiveGoal() {
        ViewModel.goal.isCompleted = true
        if let index = userData.goals.firstIndex(where: { $0.id == ViewModel.goal.id }) {
            userData.goals[index] = ViewModel.goal
        }
        dismiss()
    }
}
