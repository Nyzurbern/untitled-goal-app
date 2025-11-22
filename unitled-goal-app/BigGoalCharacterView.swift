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

    // Use a computed property so we don't reference ViewModel before init
    private var foodProgress: CGFloat {
        CGFloat(ViewModel.goal.foodprogressbar) / 250.0
    }
    
    private var drinkProgress: CGFloat {
        CGFloat(ViewModel.goal.drinksprogressbar) / 250.0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack {
                    VStack{
                        Text(
                            "Hi! My name is \(ViewModel.goal.characterName)"
                        )
                        .font(.title)

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

                    ZStack {
                        Image(ViewModel.goal.character.image)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 350, maxHeight: 350)
                        HStack {
                            NavigationLink {
                                FoodShopView(ViewModel: ViewModel)
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
                                        .foregroundColor(ViewModel.goal.foodprogressbar <= 10
                                                         ? Color.red : Color.orange)
                                        .frame(width: 70, height: 70)
                                }
                            }
                            Spacer()
                            NavigationLink {
                                DrinksShopView(ViewModel: ViewModel)
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
                                        .foregroundColor(ViewModel.goal.drinksprogressbar <= 10
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
                            ViewModel.goal.deadline,
                            format: .dateTime.day().month().year()
                        )
                        .bold()
                        .font(.title)
                    }
                    HStack {
                        Text(
                            "Food: \(Int(ViewModel.goal.foodprogressbar))/250"
                        )
                        .font(.caption)
                        .foregroundColor(.secondary)
                        Text(
                            "Water: \(Int(ViewModel.goal.drinksprogressbar))/250"
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
                            AddSubGoalPopupView(ViewModel: ViewModel)
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
                                        subgoal.isCompleted.wrappedValue
                                            .toggle()
                                        if subgoal.isCompleted.wrappedValue {
                                            ViewModel.goal.coins +=
                                            subgoal.coinReward.wrappedValue
                                        } else {
                                            ViewModel.goal.coins -=
                                            subgoal.coinReward.wrappedValue
                                        }
                                    } label: {
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
                            .onDelete { indexSet in
                                ViewModel.goal.subgoals.remove(
                                    atOffsets: indexSet
                                )
                            }
                        }
                        .listStyle(.plain)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .frame(
                            height: CGFloat(
                                ViewModel.goal.subgoals.count
                            ) * 70 + 20
                        )
                    }
                }
            }
        }
        .navigationTitle(ViewModel.goal.title)
    }
    private func didDismiss() {
        print("dismissed")
    }

    private func archiveGoal() {
        ViewModel.goal.isCompleted = true
        if let index = userData.goals.firstIndex(where: {
            $0.id == ViewModel.goal.id
        }) {
            userData.goals[index] = ViewModel.goal
        }
        dismiss()
    }
}
