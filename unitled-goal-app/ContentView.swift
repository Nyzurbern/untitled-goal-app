//
//  ContentView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var showingOnboarding: Bool = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            ReflectionArchive()
                .tabItem {
                    Label("Archive", systemImage: "book.fill")
                }
        }
        .onAppear {
            showingOnboarding = !hasSeenOnboarding
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView {
                hasSeenOnboarding = true
                showingOnboarding = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
