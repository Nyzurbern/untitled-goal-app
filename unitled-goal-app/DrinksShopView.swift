//
//  DrinksShopView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct DrinksShopView: View {
    @State private var selectedItem: Consumable?
    @State private var showingBuyConfirm = false
    @State private var showingNoBalanceAlert = false
    @State private var missingCoins = 0
    @Environment(\.dismiss) var dismiss
    @Bindable var goal: Goal
    
    let items = [
        Consumable(
            name: "Lemonade",
            dftype: "Drink",
            image: "Lemonade",
            cost: 10,
            fillAmount: 30
        ),
        Consumable(
            name: "Coffee",
            dftype: "Drink",
            image: "Coffee",
            cost: 20,
            fillAmount: 50
        ),
        Consumable(
            name: "Sodaaaaaa",
            dftype: "Drink",
            image: "soda",
            cost: 25,
            fillAmount: 60
        ),
        Consumable(
            name: "NRG Drink",
            dftype: "Drink",
            image: "NRG Drink",
            cost: 30,
            fillAmount: 70
        ),
        Consumable(
            name: "Boba",
            dftype: "Drink",
            image: "boba",
            cost: 40,
            fillAmount: 90
        ),
        Consumable(
            name: "MILK~!",
            dftype: "Drink",
            image: "milk",
            cost: 45,
            fillAmount: 100
        ),
        Consumable(name: "Frappuccino", dftype: "Drink", image: "frappuccino", cost: 50, fillAmount: 110)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                
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
        .navigationTitle("Drinks Shop")
        .toolbar{
            Text("\(goal.coins) 🪙")
                .padding(.horizontal)
        }
        .alert(
            "Buy \(selectedItem?.name ?? "item") for \(selectedItem?.cost ?? 0) coins?",
            isPresented: $showingBuyConfirm
        ) {
            Button("Sure!") {
                guard let item = selectedItem else { return }
                if goal.coins >= item.cost {
                    goal.coins -= item.cost
                    goal.drinksprogressbar += CGFloat(item.fillAmount)
                    dismiss()
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
//omigawd i hate working at selected items... i took like 2 hours to come up with this stupid idea about selecteditem being a variable
