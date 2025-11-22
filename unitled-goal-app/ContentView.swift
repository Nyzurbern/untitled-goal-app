//
//  ContentView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData = UserData(sample: false)
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var showingOnboarding: Bool = false

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .environmentObject(userData)

            ReflectionArchive()
                .tabItem {
                    Label("Archive", systemImage: "book.fill")
                }
                .environmentObject(userData)
        }
        .onAppear {
            showingOnboarding = !hasSeenOnboarding
        }
        .fullScreenCover(isPresented: $showingOnboarding) {
            OnboardingView {
                hasSeenOnboarding = true
                showingOnboarding = false
            }
            .environmentObject(userData)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
