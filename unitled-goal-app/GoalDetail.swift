////
////  GoalDetail.swift
////  SomeGoalsApp
////
////  Created by Anish Das on 15/11/25.
////
//
//import SwiftUI
//
//struct GoalDetailView: View {
//    @EnvironmentObject var userData: UserData
//    @Binding var goal: Goal
//
//    @State private var newSubTitle: String = ""
//    @State private var newReflection: String = ""
//    @State private var foodRectWidth: CGFloat = 30
//    @State private var waterRectWidth: CGFloat = 30
//
//    var body: some View {
//        ScrollView {
//            VStack{
//                Text("Character")
//                    .bold()
//                    .font(.title)
//                Image("subject nobody")
//                HStack{
//                    ZStack{
//                        Rectangle()
//                            .frame(width: 300, height: 40)
//                            .foregroundStyle(.background)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
//                                    .stroke(Color.orange, lineWidth: 3)
//                            )
//                        HStack{
//                            Rectangle()
//                                .frame(width: foodRectWidth, height: 40)
//                                .frame(maxWidth: 300, alignment: .leading)
//                                .foregroundStyle(.orange)
//                                .clipShape(RoundedRectangle(cornerRadius: 8))
//                        }
//                        Text("🍞")
//                    }
//                    Button{
//                        print("Food is served")
//                        if foodRectWidth < 300 {
//                            foodRectWidth += 10
//                        }
//                    } label: {
//                        Text("Feed")
//                            .padding()
//                            .background(.orange)
//                            .foregroundStyle(.white)
//                            .frame(height: 41.5)
//                            .clipShape(RoundedRectangle(cornerRadius: 8))
//                    }
//                }
//                HStack{
//                    ZStack{
//                        Rectangle()
//                            .frame(width: 300, height: 40)
//                            .foregroundStyle(.background)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 8).inset(by: 1.5)
//                                    .stroke(Color.blue, lineWidth: 3)
//                            )
//                        HStack{
//                            Rectangle()
//                                .frame(width: waterRectWidth, height: 40)
//                                .frame(maxWidth: 300, alignment: .leading)
//                                .foregroundStyle(.blue)
//                                .clipShape(RoundedRectangle(cornerRadius: 8))
//                        }
//                        Text("💧")
//                    }
//                    Button{
//                        print("Drinks are served")
//                        print(waterRectWidth)
//                        if waterRectWidth < 300 {
//                            waterRectWidth += 10
//                        }
//                    } label: {
//                        Text("Drink")
//                            .padding()
//                            .background(.blue)
//                            .foregroundStyle(.white)
//                            .frame(height: 41.5)
//                            .clipShape(RoundedRectangle(cornerRadius: 8))
//                    }
//                }
//            }
//        }
//            VStack(alignment: .leading, spacing: 18) {
//                // title + coins
//                HStack {
//                    VStack(alignment: .leading, spacing: 6) {
//                        TextField("Title", text: $goal.title)
//                            .font(.title2.bold())
//                        TextField("Short description", text: $goal.description)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                    Spacer()
//                    VStack {
//                        Text("Coins")
//                            .font(.caption)
//                            .foregroundColor(.secondary)
//                        Text("\(userData.coins)")
//                            .font(.title3)
//                            .bold()
//                            .foregroundStyle(.yellow)
//                    }
//                }
//
//                // deadline
//                VStack(alignment: .leading, spacing: 6) {
//                    Text("Deadline")
//                        .font(.headline)
//                    DatePicker(
//                        "Deadline",
//                        selection: $goal.deadline,
//                        displayedComponents: .date
//                    )
//                    .datePickerStyle(.compact)
//                }
//
//                // progress
//                VStack(alignment: .leading) {
//                    Text("Progress")
//                        .font(.headline)
//                    ZStack(alignment: .leading) {
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(Color.gray.opacity(0.2))
//                            .frame(height: 18)
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(
//                                LinearGradient(
//                                    colors: [.blue, .purple],
//                                    startPoint: .leading,
//                                    endPoint: .trailing
//                                )
//                            )
//                            .frame(
//                                width: max(
//                                    10,
//                                    CGFloat(goal.progress)
//                                        * (UIScreen.main.bounds.width - 48)
//                                ),
//                                height: 18
//                            )
//                            .animation(.spring(), value: goal.progress)
//                    }
//                    Text("\(Int(goal.progress * 100))%")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//
//                // subgoals
//                VStack(alignment: .leading, spacing: 10) {
//                    HStack {
//                        Text("Sub-goals")
//                            .font(.headline)
//                        Spacer()
//                    }
//
//                    ForEach(goal.subgoals.indices, id: \.self) { i in
//                        HStack {
//                            Button {
//                                // toggle completion
//                                goal.subgoals[i].isCompleted.toggle()
//                                if goal.subgoals[i].isCompleted {
//                                    userData.coins +=
//                                        goal.subgoals[i].coinReward
//                                } else {
//                                    // if unchecking, optionally deduct coins or leave as-is
//                                }
//                            } label: {
//                                Image(
//                                    systemName: goal.subgoals[i].isCompleted
//                                        ? "checkmark.circle.fill" : "circle"
//                                )
//                                .foregroundColor(
//                                    goal.subgoals[i].isCompleted
//                                        ? .green : .primary
//                                )
//                            }
//
//                            TextField("Sub-goal", text: $goal.subgoals[i].title)
//
//                            Spacer()
//
//                            Button {
//                                // remove subgoal
//                                goal.subgoals.remove(at: i)
//                            } label: {
//                                Image(systemName: "trash")
//                                    .foregroundColor(.red)
//                            }
//                        }
//                        .padding(8)
//                        .background(Color.gray.opacity(0.06))
//                        .cornerRadius(10)
//                    }
//
//                    // add subgoal field
//                    NavigationStack {
//                        HStack {
//                            NavigationLink {
//                                AddSubGoalPopupView()
//                            } label: {
//                                Text("Create a subgoal!")
//                                    .padding()
//                                    .background(Color.blue)
//                                    .foregroundColor(.white)
//                                    .cornerRadius(8)
//                            }
//                        }
//                    }
//                }
//
//                // reflections
//                VStack(alignment: .leading, spacing: 8) {
//                    Text("Reflections")
//                        .font(.headline)
//                    ForEach(goal.reflections, id: \.self) { ref in
//                        Text("• \(ref)")
//                            .padding(8)
//                            .background(Color.gray.opacity(0.07))
//                            .cornerRadius(8)
//                    }
//
//                    TextEditor(text: $newReflection)
//                        .frame(height: 110)
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 8).stroke(
//                                Color.gray.opacity(0.3)
//                            )
//                        )
//
//                    Button("Add Reflection") {
//                        let trimmed = newReflection.trimmingCharacters(
//                            in: .whitespacesAndNewlines
//                        )
//                        guard !trimmed.isEmpty else { return }
//                        goal.reflections.append(trimmed)
//                        newReflection = ""
//                    }
//                    .buttonStyle(.borderedProminent)
//                    .tint(.blue)
//                }
//
//                Spacer(minLength: 40)
//            }
//            .padding()
//    }
//}
//
//#Preview {
//    GoalDetailView(
//        goal: .constant(
//            Goal(
//                title: "Test",
//                description: "Desc",
//                deadline: Date(),
//                subgoals: [Subgoal(title: "A"), Subgoal(title: "B")], character: Character(profileImage: "Subject 3" ,image: "subject nobody", waterLevel: 30, foodLevel: 30)
//                subgoals: [Subgoal(title: "A"), Subgoal(title: "B")],
//                isCompleted: false,
//                reflections: [],
//                character: Character(profileImage: "Subject 3", image: "subject nobody", waterLevel: 30, foodLevel: 30),
//                coins: 10
//            )
//        )
//    )
//    .environmentObject(UserData(sample: true))
//}
