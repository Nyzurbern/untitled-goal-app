//
//  ContentView.swift
//  SomeGoalsApp
//
//  Created by T Krobot on 14/11/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var userData = UserData(sample: false)
    
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
    }
}
