//
//  InsuCarouselView.swift
//  Loop
//
//  Created for INSU onboarding flow
//

import SwiftUI

struct InsuCarouselView: View {
    @State private var currentSlide = 0

    var onGetStarted: () -> Void
    var onLoginTapped: () -> Void

    // Slide content definitions
    private let slides: [CarouselSlideContent] = [
        CarouselSlideContent(
            title: "Type 1 Diabetes Shouldn't be a Challenge.",
            showGetStartedButton: false,
            showLoginLink: false
        ),
        CarouselSlideContent(
            title: "Log Less.\nKnow More.",
            showGetStartedButton: false,
            showLoginLink: false
        ),
        CarouselSlideContent(
            title: "Welcome to\nInsu.",
            showGetStartedButton: true,
            showLoginLink: true
        )
    ]

    var body: some View {
        ZStack {
            // Animated wave background (changes with slide)
            InsuWaveBackgroundView(slideIndex: currentSlide)
                .animation(.easeInOut(duration: 0.5), value: currentSlide)

            VStack {
                // Swipeable carousel
                TabView(selection: $currentSlide) {
                    ForEach(0..<slides.count, id: \.self) { index in
                        InsuCarouselSlideView(
                            content: slides[index],
                            slideIndex: index,
                            onGetStarted: onGetStarted,
                            onLoginTapped: onLoginTapped
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))

                // Custom page indicator
                InsuPageIndicator(
                    numberOfPages: slides.count,
                    currentPage: currentSlide
                )
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
    }
}

// MARK: - Preview

#if DEBUG
struct InsuCarouselView_Previews: PreviewProvider {
    static var previews: some View {
        InsuCarouselView(
            onGetStarted: {},
            onLoginTapped: {}
        )
    }
}
#endif
