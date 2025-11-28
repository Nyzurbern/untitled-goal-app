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
            Group {
                if goals.isEmpty {
                    ContentUnavailableView("No Reflection", systemImage: "book", description: Text("A prompt for you to insert your reflections will only be presented if your goal is due."))
                    
                } else {
                    List {
                        ForEach(
                            goals.filter {
                                $0.isCompleted
                            }
                        ) { goal in
                            Section {
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
