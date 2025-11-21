//
//  ReflectionSheetView.swift
//  SomeGoalsApp
//
//  Created by Administrator on 20/11/25.
//

import SwiftUI

struct ReflectionSheetView: View {
    @Binding var goal: Goal
    @Binding var isShowingReflectionSheet: Bool
    let archiveGoal: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Goal Details")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What challenges or obstacles did I experience? How did I overcome them, or what prevented me from doing so?")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Type here...", text: $goal.challenges)
                            .textInputAutocapitalization(.sentences)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What specific actions or habits contributed most to my progress?")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Type here...", text: $goal.actionsorhabits)
                            .textInputAutocapitalization(.sentences)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What resources or support were most helpful?")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        TextField("Type here...", text: $goal.resourcesorsupport)
                            .textInputAutocapitalization(.sentences)
                    }
                }
                
                Section {
                    Button(action: archiveGoal) {
                        HStack {
                            Spacer()
                            Text("Archive Goal")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Goal Reflection")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
            }
        }
    }
}
