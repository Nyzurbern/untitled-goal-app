//
//  ReflectionCard.swift
//  unitled-goal-app
//
//  Created by T Krobot on 21/11/25.
//

import SwiftUI

struct ReflectionCard: View {
    @State private var clickToSeeMore = false
    
    var goal: Goal
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Goal: " + goal.title)
                    .font(.title)
                HStack {
                    Text("Status:")
                        .font(.title2)
                    if goal.failed {
                        Text("Failed")
                            .foregroundStyle(.red)
                            .font(.title2)
                    } else {
                        Text("Achieved!")
                            .foregroundStyle(.green)
                            .font(.title2)
                    }
                }
                HStack {
                    Text("Archived on:")
                        .font(.title2)
                    Text(goal.deadline, format: .dateTime.day().month().year())
                        .font(.title2)
                }
            }
            Divider()
                .frame(maxWidth: 250)
            Button("Click to see more") {
                clickToSeeMore.toggle()
            }
            .sheet(isPresented: $clickToSeeMore) {
                ReflectionExpandedView(goal: goal)
            }
    
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    ReflectionCard(goal: Goal(title: "Get L1R5 of 6", description: "Sure", deadline: Date(), character: Character(profileImage: "no", image: "s", waterLevel: 1, foodLevel: 2), coins: 3))
}
