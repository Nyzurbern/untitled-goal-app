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
    @ObservedObject var ViewModel: GoalViewModel
    @Environment(\.dismiss) var dismiss

    let items = [
        Consumable(
            name: "Chips",
            dftype: "Food",
            image: "Chips",
            cost: 10,
            fillAmount: 30
        ),
        Consumable(
            name: "Broccoli",
            dftype: "Food",
            image: "Brocoli",
            cost: 20,
            fillAmount: 40
        ),
        Consumable(name: "Bao", dftype: "Food", image: "Bao", cost: 30, fillAmount: 50),
        Consumable(name: "Chocolate", dftype: "Food", image: "Chocolate", cost: 40, fillAmount: 60),
        Consumable(
            name: "Cake",
            dftype: "Food",
            image: "Cake",
            cost: 50,
            fillAmount: 70
        ),
        Consumable(name: "Dango", dftype: "Food", image: "Dango", cost: 60, fillAmount: 80),
        Consumable(name: "Avacado", dftype: "Food", image: "Avacado", cost: 70, fillAmount: 90)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("Food Shop")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top)

                    if ViewModel.goal.coins < 0 {
                        Text("Coins: \(ViewModel.goal.coins) 😬")
                            .foregroundColor(.red)
                    } else {
                        Text("Coins: \(ViewModel.goal.coins) 🪙")
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
                                    .overlay(Image(item.image)
                                        .resizable()
                                        .scaledToFit())
                                Text(item.name)
                                    .bold()
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
                if ViewModel.goal.coins >= item.cost {
                    ViewModel.goal.coins -= item.cost
                    ViewModel.goal.foodprogressbar += CGFloat(item.fillAmount)
                    dismiss()
                } else {
                    missingCoins = item.cost - ViewModel.goal.coins
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
