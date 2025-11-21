////
////  FailedGoalView.swift
////  SomeGoalsApp
////
////  Created by T Krobot on 15/11/25.
////
//
//import SwiftUI
//
//struct FailOrSuccessView: View {
//    @EnvironmentObject var userData: UserData
//    @State private var FinalReflectionDone = false
//    @Binding var goal: Goal
//    
//    var body: some View {
//        VStack {
//            Text("How does it feel to have achieved your goal? What were some limitations you faced and how did you overcome it?")
//                .frame(width: 350)
//                .bold()
//                .font(.title3)
//            
//            TextField("Your reflection..", text: $reflectionText) // Use renamed variable
//                .frame(width: 350)
//                .textFieldStyle(.roundedBorder)
//            
//            Text("See how far your character has come!")
//                .frame(width: 350)
//                .bold()
//                .font(.title3)
//            
//            Button {
//                // Save the reflection
//                goal.challenges = reflectionText
//                FinalReflectionDone = true
//            } label: {
//                Text("Next")
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 14)
//                    .background(RoundedRectangle(cornerRadius: 10) .fill(Color.blue))
//                    .foregroundStyle(.white)
//            }
//        }
//        .padding(40)
//        .sheet(isPresented: $FinalReflectionDone) {
//            HomeView(reflection: $reflection) // Fix parameter name
//                .environmentObject(userData)
//        }
//    }
//}
