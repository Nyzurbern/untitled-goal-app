//  ReflectionView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI

struct ReflectionArchive: View {
    @EnvironmentObject var userData: UserData

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 12) {
                Text("Reflection Journal")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)

                if userData.goals.isEmpty {
                    Text(
                        "No goals yet. Add a goal from Home to start reflecting."
                    )
                    .foregroundColor(.secondary)
                    .padding()
                    Spacer()
                } else {
                    List(userData.goals) { goal in
                        VStack(alignment: .trailing) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 25.0, style: .continuous)
                                    .fill(Color(.white))
                                VStack {
                                    Text(goal.title)
                                        .font(.subheadline)
                                        .bold()
                                    Text(
                                        "What specific actions or habits contributed most to my progress?"
                                    )
                                    .font(.caption)
                                    Text(goal.actionsorhabits)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(
                                        "What challenges or obstacles did I experience? How did I overcome them, or what prevented me from doing so?"
                                    )
                                    .font(.caption)
                                    Text(goal.challenges)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    Text(
                                        "What resources or support were most helpful?"
                                    )
                                    .font(.caption)
                                    Text(goal.resourcesorsupport)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
 
                                
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ReflectionArchive().environmentObject(UserData(sample: true))
}
