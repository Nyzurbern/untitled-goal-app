//
//  GoalCard.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct GoalCardView: View {
    var goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text(goal.title)
                        .font(.headline)
                        .bold()
                    Text(goal.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                Spacer()
                Text("\(Int(goal.progress * 100))%")
                    .bold()
            }
            
            Text("Deadline: \(goal.deadline.formatted(.dateTime.month().day().year()))")
                .font(.caption)
                .foregroundColor(.secondary)
            
            ProgressView(value: goal.progress)
                .frame(height: 8)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 14).fill(.ultraThinMaterial))
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
    }
}
//
//#Preview(traits: .sizeThatFitsLayout) {
//    GoalCardView(goal: Goal(title: "Example", description: "Quick test", deadline: Date(), subgoals: [
//        Subgoal(title: "A", isCompleted: true),
//        Subgoal(title: "B")
//    ], character: Character(profileImage: "Subject 3", image: "subject nobody", waterLevel: 30, foodLevel: 30), coins: 10))
//        .padding()
//}
