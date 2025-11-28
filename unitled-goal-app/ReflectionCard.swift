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
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(goal.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                HStack {
                    if goal.failed {
                        Text("Failed")
                            .foregroundStyle(.red)
                            .font(.default)
                    } else {
                        Text("Achieved")
                            .foregroundStyle(.green)
                            .font(.default)
                    }
                }
                HStack {
                    Text("Archived on:")
                    Text(goal.deadline, format: .dateTime.day().month().year())
                }
                .font(.default)
                .foregroundStyle(.gray)
            }
            VStack(alignment: .center){
                Divider()
                    .frame(maxWidth: 300)
                Text("Tap to see more")
            }
    
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}

//#Preview {
//    ReflectionCard(goal: Goal(title: "Get L1R5 of 6", description: "Sure", deadline: Date(), character: Character(profileImage: "no", image: "s", waterLevel: 1, foodLevel: 2), coins: 3))
//}
