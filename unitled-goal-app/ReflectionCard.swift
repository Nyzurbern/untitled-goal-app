//
//  ReflectionCard.swift
//  unitled-goal-app
//
//  Created by T Krobot on 21/11/25.
//

import SwiftUI

struct ReflectionCard: View {
    @State private var clickToSeeMore = false
    
    @Bindable var goal: Goal
    
    var body: some View {
        VStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Goal: " + goal.title)
                    .font(.title)
                    .foregroundStyle(.black)
                HStack {
                    Text("Status:")
                        .font(.title2)
                        .foregroundStyle(.black)
                    if goal.failed {
                        Text("Failed")
                            .foregroundStyle(.red)
                            .font(.title2)
                    } else {
                        Text("Achieved")
                            .foregroundStyle(.green)
                            .font(.title2)
                    }
                }
                HStack {
                    Text("Archived on:")
                        .font(.title2)
                        .foregroundStyle(.black)
                    Text(goal.deadline, format: .dateTime.day().month().year())
                        .font(.title2)
                        .foregroundStyle(.black)
                }
            }
            Divider()
                .frame(maxWidth: 300)
            Text("Click to see more")
    
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}

//#Preview {
//    ReflectionCard(goal: Goal(title: "Get L1R5 of 6", description: "Sure", deadline: Date(), character: Character(profileImage: "no", image: "s", waterLevel: 1, foodLevel: 2), coins: 3))
//}
