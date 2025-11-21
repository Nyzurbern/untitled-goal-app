//
//  unitled_goal_appApp.swift
//  unitled-goal-app
//
//  Created by T Krobot on 21/11/25.
//

import SwiftUI

@main
struct UnitledGoalApp: App {
    @StateObject private var userData = UserData() // shared across app

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .onAppear {
                    NotificationManager.shared.requestAuthorization()
                }
        }
    }
}
