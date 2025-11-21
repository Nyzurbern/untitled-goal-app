////
////  DueDatePopupView.swift
////  SomeGoalsApp
////
////  Created by T Krobot on 15/11/25.
////
//
//import SwiftUI
//
//struct DueDatePopupView: View {
//    @EnvironmentObject var userData: UserData
//    @State private var FailedGoal = false
//    @State private var ExtendDueDate = false
//    @State private var ICompletedMyGoal = false
//
//    
//    var body: some View {
//        NavigationStack {
//            VStack(spacing: 12) {
//                Button {
//                    FailedGoal = true
//                } label: {
//                    Text("I didn't manage to do it..")
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 14)
//                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.red))
//                        .foregroundStyle(.white)
//                }
//                Button {
//                    ExtendDueDate = true
//                } label: {
//                    Text("Let me extend the date papi!")
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 14)
//                        .background(RoundedRectangle(cornerRadius: 10) .fill(Color.yellow))
//                        .foregroundStyle(.white)
//                }
//                Button {
//                    ICompletedMyGoal = true
//                } label: {
//                    Text("I completed my goal!!!!")
//                        .padding(.vertical, 10)
//                        .padding(.horizontal, 14)
//                        .background(RoundedRectangle(cornerRadius: 10) .fill(Color.green))
//                        .foregroundStyle(.white)
//                }
//            }
//            .navigationTitle("")
//            .sheet(isPresented: $FailedGoal) {
//                FailOrSuccessView(reflection: $reflection)
//            }
//            .sheet(isPresented: $ExtendDueDate) {
//                ExtendDueDateView()
//            }
//            .sheet(isPresented: $ICompletedMyGoal) {
//                FailOrSuccessView(reflection: $reflection) 
//            }
//        }
//    }
//}
