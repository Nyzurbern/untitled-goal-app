//
//  ReflectionExpandedView.swift
//  unitled-goal-app
//
//  Created by T Krobot on 21/11/25.
//

import SwiftUI

struct ReflectionExpandedView: View {
    @State var goal: Goal
    
    var body: some View {
        Form {
            Section ("What specific actions or habits contributed most to my progress?"){
                Text(goal.actionsorhabits)
            }
            
            Section (goal.failed ? "What challenges prevented me from achieving my goal?" : "What challenges or obstacles did I experience? How did I overcome them?") {
                Text(goal.challenges)
            }
        
            Section ("What resources or support were most helpful?") {
                Text(goal.resourcesorsupport)
            }
        }
        .navigationTitle(goal.title)
    }
}

//#Preview {
//    ReflectionExpandedView(goal: Goal(title: "Get L1R5 of 6", description: "Sure", deadline: Date(), character: Character(profileImage: "no", image: "s", waterLevel: 1, foodLevel: 2), coins: 3))
//}
