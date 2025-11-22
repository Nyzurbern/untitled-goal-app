//
//  ReflectionExpandedView.swift
//  unitled-goal-app
//
//  Created by T Krobot on 21/11/25.
//

import SwiftUI

struct ReflectionExpandedView: View {
    var goal: Goal
    
    var body: some View {
        VStack {
            Text(goal.title)
                .font(.title)
            Text("What specific actions or habits contributed most to my progress?")
                .font(.title2)
            Divider()
                .frame(maxWidth: 300)
            Text(goal.actionsorhabits)
        }
    }
}

#Preview {
    ReflectionExpandedView(goal: Goal(title: "Get L1R5 of 6", description: "Sure", deadline: Date(), character: Character(profileImage: "no", image: "s", waterLevel: 1, foodLevel: 2), coins: 3))
}
