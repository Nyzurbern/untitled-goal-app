//
//  FoodShopView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct FoodShopView: View {
    @State private var selectedItem: Consumable?
    @State private var showingBuyConfirm = false
    @State private var showingNoBalanceAlert = false
    @State private var missingCoins = 0
    @Binding var goal: Goal

    let items = [
        Consumable(
            name: "Chips",
            dftype: "Food",
            image: "subject nobody",
            cost: 10,
            fillAmount: 30
        ),
        Consumable(
            name: "Broccoli",
            dftype: "Food",
            image: "subject nobody",
            cost: 20,
            fillAmount: 50
        ),
        Consumable(
            name: "Cake",
            dftype: "Food",
            image: "subject nobody",
            cost: 30,
            fillAmount: 30
        ),
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Food Shop")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)

                    if goal.coins < 0 {
                        Text("Coins: \(goal.coins) 😬")
                            .foregroundColor(.red)
                    } else {
                        Text("Coins: \(goal.coins) 🪙")
                            .font(.title2)
                            .foregroundStyle(.yellow)
                    }

                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        spacing: 16
                    ) {
                        ForEach(Array(items.enumerated()), id: \.offset) {
                            _,
                            item in
                            VStack(spacing: 8) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue.opacity(0.12))
                                    .frame(height: 120)
                                    .overlay(Text(item.name).bold())
                                Text("\(item.cost) coins")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                Button("Buy") {
                                    selectedItem = item
                                    showingBuyConfirm = true
                                }
                                .buttonStyle(.borderedProminent)
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12).fill(
                                    .ultraThinMaterial
                                )
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .alert(
            "Buy \(selectedItem?.name ?? "item") for \(selectedItem?.cost ?? 0) coins?",
            isPresented: $showingBuyConfirm
        ) {
            Button("Sure!") {
                guard let item = selectedItem else { return }
                if goal.coins >= item.cost {
                    goal.coins -= item.cost
                    goal.foodprogressbar += CGFloat(item.fillAmount)
                } else {
                    missingCoins = item.cost - goal.coins
                    showingNoBalanceAlert = true
                }
            }
            Button("Nah", role: .cancel) {
                selectedItem = nil
            }
        }
        .alert(
            "You are missing \(missingCoins) coins",
            isPresented: $showingNoBalanceAlert
        ) {
            Button("Oh no :(", role: .cancel) {
                selectedItem = nil
            }
        }
    }
}
