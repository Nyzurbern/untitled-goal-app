//
//  BigGoalCharacterView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftData
import SwiftUI
import UIKit

struct BigGoalCharacterView: View {
    @State private var isShowingReflectionSheet = false
    @Environment(\.dismiss) private var dismiss
    @Bindable var goal: Goal
    @State private var selectedSubgoalID: Subgoal.ID?

    private var foodProgress: CGFloat {
        CGFloat(goal.foodprogressbar) / 250.0
    }

    private var drinkProgress: CGFloat {
        CGFloat(goal.drinksprogressbar) / 250.0
    }

    // Derived progress toward revival
    private var completedCount: Int {
        goal.subgoals.filter { $0.isCompleted }.count
    }

    private var remainingNeeded: Int {
        max(0, 5 - completedCount)
    }

    // Dead only if both bars are exactly 0
    private var isDehydratedAndStarving: Bool {
        goal.foodprogressbar <= 0 && goal.drinksprogressbar <= 0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                characterHeaderSection
                subgoalsSection
            }
            .padding(.horizontal)
        }
        .navigationTitle(goal.title)
        .sheet(
            isPresented: Binding(
                get: { selectedSubgoalID != nil },
                set: { if !$0 { selectedSubgoalID = nil } }
            )
        ) {
            if let subgoalID = selectedSubgoalID,
               let index = goal.subgoals.firstIndex(where: { $0.id == subgoalID }) {
                SubGoalEditingView(subgoal: $goal.subgoals[index], goal: goal)
            } else {
                Text("Subgoal not found")
            }
        }
        // Reset bars to 30 only when character is revived (remainingNeeded crosses to 0)
        // and only if the character was actually dead (both bars were 0).
        .onChange(of: remainingNeeded) { oldValue, newValue in
            if oldValue > 0, newValue == 0, isDehydratedAndStarving {
                goal.foodprogressbar = 30
                goal.drinksprogressbar = 30
            }
        }
    }

    private var characterHeaderSection: some View {
        VStack(spacing: 16) {

            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Meet")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(goal.characterName)
                        .font(.title2.bold())
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text("Due Date")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(goal.deadline, style: .date)
                        .font(.title3.bold())
                        .foregroundColor(.primary)
                }
            }
            if remainingNeeded == 0 || !isDehydratedAndStarving {
                ZStack {
                    Image(goal.character.image)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 300, maxHeight: 300)
                        .overlay(warningOverlay)

                    HStack {
                        foodButton
                        Spacer()
                        drinkButton
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                if goal.character.profileImage == "Male Icon" {
                    Image("dead male")
                        .resizable()
                        .scaledToFit()
                } else if goal.character.profileImage == "Female Icon" {
                    Image("dead female")
                        .resizable()
                        .scaledToFit()
                } else if goal.character.profileImage == "Female Star Icon" {
                    Image("dead female star")
                        .resizable()
                        .scaledToFit()
                }
                Spacer()
                VStack(spacing: 8) {
                    Text("Complete some subgoals to revive your character!")
                        .font(.title2.weight(.semibold))
                    Text("\(remainingNeeded) more to go")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.06))
        .cornerRadius(16)
    }

    private var warningOverlay: some View {
        Group {
            if goal.foodprogressbar <= 10 || goal.drinksprogressbar <= 10 {
                VStack {
                    HStack(spacing: 8) {
                        if goal.foodprogressbar <= 10 {
                            WarningBadge(text: "Hungry", color: .red)
                        }
                        if goal.drinksprogressbar <= 10 {
                            WarningBadge(text: "Thirsty", color: .red)
                        }
                    }
                    Spacer()
                }
                .padding(8)
            }
        }
    }

    private var foodButton: some View {
        NavigationLink {
            FoodShopView(goal: goal)
        } label: {
            ProgressCircleButton(
                emoji: "🍴",
                progress: foodProgress,
                color: goal.foodprogressbar <= 10 ? .red : .orange
            )
        }
    }

    private var drinkButton: some View {
        NavigationLink {
            DrinksShopView(goal: goal)
        } label: {
            ProgressCircleButton(
                emoji: "🧋",
                progress: drinkProgress,
                color: goal.drinksprogressbar <= 10 ? .red : .blue
            )
        }
    }

    private var subgoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            subgoalsHeader

            if goal.subgoals.isEmpty {
                emptySubgoalsMessage
            } else {
                subgoalsList
            }
        }
    }

    private var subgoalsHeader: some View {
        HStack {
            Text("Subgoals")
                .font(.title2.bold())
            Spacer()

            NavigationLink {
                AddSubGoalPopupView(goal: goal)
            } label: {
                Image(systemName: "plus.circle.fill")
                    .padding(.vertical, 10)
                    .padding(.horizontal, 14)
                    .background(
                        RoundedRectangle(cornerRadius: 10).fill(Color.blue)
                    )
                    .foregroundStyle(.white)
            }
        }
    }

    private var emptySubgoalsMessage: some View {
        Text("No subgoals yet. Add one to get started!")
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding()
    }

    private var subgoalsList: some View {
        List {
            ForEach($goal.subgoals) { subgoal in
                SubgoalRow(
                    subgoal: subgoal,
                    goal: goal,
                    selectedSubgoalID: $selectedSubgoalID
                )
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.clear)
        .frame(height: CGFloat(goal.subgoals.count) * 70 + 20)
    }
}

struct ProgressPill: View {
    let icon: String
    let value: Int
    let max: Int
    let color: Color

    private var progress: Double {
        Double(value) / Double(max)
    }

    var body: some View {
        HStack(spacing: 8) {
            Text(icon)
                .font(.system(size: 16))

            Text("\(value)/\(max)")
                .font(.caption)
                .bold()
                .monospacedDigit()

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width, height: 4)
                        .opacity(0.3)
                        .foregroundColor(color)

                    Rectangle()
                        .frame(
                            width: min(
                                CGFloat(progress) * geometry.size.width,
                                geometry.size.width
                            ),
                            height: 4
                        )
                        .foregroundColor(color)
                }
                .cornerRadius(2)
            }
            .frame(width: 40, height: 4)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(color.opacity(0.1))
        .cornerRadius(20)
    }
}

struct WarningBadge: View {
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.caption2)
            Text(text)
                .font(.caption2)
                .bold()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(color.opacity(0.9))
        .foregroundColor(.white)
        .cornerRadius(6)
    }
}

struct ProgressCircleButton: View {
    let emoji: String
    let progress: CGFloat
    let color: Color

    var body: some View {
        ZStack {
            if #available(iOS 26.0, *) {
                Text(emoji)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .glassEffect()
                    .font(.system(size: 36))
            } else {
                Text(emoji)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .font(.system(size: 36))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }

            Circle()
                .stroke(lineWidth: 5)
                .opacity(0.5)
                .foregroundStyle(.gray)
                .frame(width: 50, height: 50)

            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )
                .foregroundColor(color)
                .frame(width: 70, height: 70)
        }
    }
}

struct SubgoalRow: View {
    @Binding var subgoal: Subgoal
    let goal: Goal
    @Binding var selectedSubgoalID: Subgoal.ID?

    var body: some View {
        HStack {
            Button {
                withAnimation(
                    .interactiveSpring(response: 0.4, dampingFraction: 0.6)
                ) {
                    subgoal.isCompleted.toggle()
                    if subgoal.isCompleted {
                        goal.coins += subgoal.coinReward
                    } else {
                        goal.coins -= subgoal.coinReward
                    }
                }
            } label: {
                Image(
                    systemName: subgoal.isCompleted
                    ? "checkmark.circle.fill" : "circle"
                )
                .foregroundColor(subgoal.isCompleted ? .green : .primary)
                .font(.title2)
                .scaleEffect(subgoal.isCompleted ? 1.1 : 1.0)
                .rotationEffect(.degrees(subgoal.isCompleted ? 360 : 0))
            }

            TextField("Subgoal", text: $subgoal.title)
                .font(.body)

            Spacer()

            Text(subgoal.deadline, style: .date)
                .font(.caption)
                .foregroundColor(.orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(4)
        }
        .padding(.vertical, 4)
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                if let index = goal.subgoals.firstIndex(where: {
                    $0.id == subgoal.id
                }) {
                    goal.subgoals.remove(at: index)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }

            Button {
                selectedSubgoalID = subgoal.id
            } label: {
                Label("Edit", systemImage: "pencil")
            }
        }
    }
}
