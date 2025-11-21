//
//  ReflectionCard.swift
//  unitled-goal-app
//
//  Created by T Krobot on 21/11/25.
//

import SwiftUI

struct ReflectionCard: View {
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
                    Text("Reflected on:")
                        .font(.title2)
                    Text(goal.deadline, format: .dateTime.day().month().year())
                        .font(.title2)
                }
            }
            Divider()
                .frame(maxWidth: 250)
            Text("Click to see more")
                .font(.title2)
                .foregroundStyle(.blue)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}

#Preview {
    ReflectionCard(goal: Goal(title: "Get L1R5 of 6", description: "Sure", deadline: Date(), character: Character(profileImage: "no", image: "s", waterLevel: 1, foodLevel: 2), coins: 3))
}
