//  ReflectionView.swift
//  SomeGoalsApp
//
//  Created by Anish Das on 15/11/25.
//

import SwiftUI
import SwiftData

struct ReflectionArchive: View {
    @EnvironmentObject var userData: UserData
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Goal.sortIndex) var goals: [Goal]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if goals.isEmpty {
                        Text(
                            "No goals yet. Add a goal from the Home page to start reflecting."
                        )
                        .foregroundColor(.secondary)
                        .padding()

                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(
                                goals.filter {
                                    $0.isCompleted
                                }
                            ) { goal in
                                NavigationLink {
                                    ReflectionExpandedView(goal: goal)
                                } label: {
                                    ReflectionCard(goal: goal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Reflection Journal")
        }
    }
}

#Preview {
    ReflectionArchive()
}
