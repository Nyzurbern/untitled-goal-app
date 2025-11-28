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
        ScrollView {
            VStack {
                Text(goal.title)
                    .font(.title)
                    .bold()
                    .padding()
                Text("What specific actions or habits contributed most to my progress?")
                    .font(.title2)
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black, lineWidth: 2)
                        .foregroundStyle(.background)
                        .frame(width: 325, height: 80)
                    Text(goal.actionsorhabits)
                }
                if goal.failed {
                    Text("What challenges prevented me from achieving my goal?")
                        .font(.title2)
                        .frame(maxWidth:315)
                } else {
                    Text("What challenges or obstacles did I experience? How did I overcome them?")
                        .font(.title2)
                        .frame(maxWidth:315)
                }
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black, lineWidth: 2)
                        .foregroundStyle(.background)
                        .frame(width: 325, height: 80)
                    Text(goal.challenges)
                }
                Text("What resources or support were most helpful?")
                    .font(.title2)
                    .frame(maxWidth:315)
                ZStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.black, lineWidth: 2)
                        .foregroundStyle(.background)
                        .frame(width: 325, height: 80)
                    Text(goal.resourcesorsupport)
                }
            }
            .frame(width: 350)
        }
    }
}

//#Preview {
//    ReflectionExpandedView(goal: Goal(title: "Get L1R5 of 6", description: "Sure", deadline: Date(), character: Character(profileImage: "no", image: "s", waterLevel: 1, foodLevel: 2), coins: 3))
//}
