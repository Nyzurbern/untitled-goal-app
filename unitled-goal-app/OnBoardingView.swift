//
//  OnBoardingView.swift
//  unitled-goal-app
//
//  Created by Anish Das on 22/11/25.
//

import SwiftUI

struct OnboardingPage {
    let title: String
    let subtitle: String
    let description: String
    let systemImage: String
    let gradient: [Color]      
    let accent: Color
}

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    let onFinish: () -> Void
    @State private var currentIndex: Int = 0

    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "Welcome to Golaire",
            subtitle: "A goal driven companion",
            description: "Turn big goals into tiny consistent steps. Create goals, add sub goals, earn coins and care for your character all designed to keep you focused and proud of progress.",
            systemImage: "sparkles",
            gradient: [Color(red: 0.02, green: 0.42, blue: 0.92),
                       Color(red: 0.44, green: 0.09, blue: 0.85)],
            accent: Color(red: 0.12, green: 0.05, blue: 0.60)
        ),
        OnboardingPage(
            title: "Micro steps that matter",
            subtitle: "Sub goals and rewards",
            description: "Break ambitions into small actionable sub goals. Complete them to earn coins and meaningful progress small wins keep momentum alive.",
            systemImage: "list.bullet.rectangle",
            gradient: [Color(red: 0.98, green: 0.60, blue: 0.15),
                       Color(red: 0.93, green: 0.23, blue: 0.52)],
            accent: Color(red: 0.80, green: 0.21, blue: 0.45)
        ),
        OnboardingPage(
            title: "Feed and Hydrate",
            subtitle: "Care for your character",
            description: "Use coins to buy food and drinks to refill your character’s bars. Keep bars topped up low bars show clear alerts and impact your progress visuals.",
            systemImage: "cup.and.saucer.fill",
            gradient: [Color(red: 0.06, green: 0.75, blue: 0.55),
                       Color(red: 0.05, green: 0.51, blue: 0.98)],
            accent: Color(red: 0.00, green: 0.48, blue: 0.64)
        ),
        OnboardingPage(
            title: "Reflect and Improve",
            subtitle: "Learn from every deadline",
            description: "When a goal is due, reflect thoughtfully. Capture what worked, what did not, and the resources that helped. Your reflections become a powerful personal archive.",
            systemImage: "book.closed.fill",
            gradient: [Color(red: 0.38, green: 0.16, blue: 0.78),
                       Color(red: 0.12, green: 0.62, blue: 0.85)],
            accent: Color(red: 0.05, green: 0.35, blue: 0.75)
        )
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: pages[currentIndex].gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button(action: skip) {
                        Text("Skip")
                            .font(.callout.weight(.semibold))
                            .foregroundColor(.white.opacity(0.92))
                    }
                    .padding(.trailing, 20)
                }

                Spacer()

                TabView(selection: $currentIndex) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        let page = pages[i]
                        VStack(spacing: 20) {
                            Image(systemName: page.systemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 8)

                            Text(page.title)
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)

                            Text(page.subtitle)
                                .font(.title3.weight(.medium))
                                .foregroundColor(.white.opacity(0.95))
                                .multilineTextAlignment(.center)

                            Text(page.description)
                                .font(.body)
                                .foregroundColor(.white.opacity(0.92))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                        .tag(i)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentIndex)

                HStack(spacing: 10) {
                    ForEach(0..<pages.count, id: \.self) { i in
                        Capsule()
                            .fill(i == currentIndex ? Color.white : Color.white.opacity(0.35))
                            .frame(width: i == currentIndex ? 28 : 8, height: 8)
                            .animation(.easeInOut(duration: 0.2), value: currentIndex)
                    }
                }
                .padding(.top, 20)

                if currentIndex == pages.count - 1 {
                    Button(action: next) {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(pages[currentIndex].accent)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.vertical, 30)
                    }
                }
            }
            .padding(.top, 24)
        }
        .interactiveDismissDisabled()
    }

    private func skip() {
        hasSeenOnboarding = true
        onFinish()
    }

    private func next() {
        hasSeenOnboarding = true
        onFinish()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onFinish: { })
            .previewDevice("iPhone 15")
    }
}
