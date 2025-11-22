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
                if userData.goals.isEmpty {
                    Text(
                        "No goals yet. Add a goal from Home to start reflecting."
                    )
                    .foregroundColor(.secondary)
                    .padding()

                } else {
                    LazyVStack(spacing: 16) {
                        ForEach(
                            $userData.goals.filter {
                                $0.wrappedValue.isCompleted
                            }
                        ) { $goal in
                            NavigationLink {
                            } label: {
                                ReflectionCard(goal: goal)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Reflection Archive")
        }
    }
}

#Preview {
    ReflectionArchive().environmentObject(UserData(sample: true))
}
