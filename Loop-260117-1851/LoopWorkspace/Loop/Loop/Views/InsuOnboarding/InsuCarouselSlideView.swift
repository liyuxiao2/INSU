//
//  InsuCarouselSlideView.swift
//  Loop
//
//  Created for INSU onboarding flow
//  Typography from Figma: Title 36px Semibold, Button 24px Semibold
//

import SwiftUI

// MARK: - Slide Content Model

struct CarouselSlideContent {
    let title: String
    let showGetStartedButton: Bool
    let showLoginLink: Bool
}

// MARK: - Carousel Slide View

struct InsuCarouselSlideView: View {
    let content: CarouselSlideContent
    let slideIndex: Int
    var onGetStarted: () -> Void
    var onLoginTapped: () -> Void

    // Figma dimensions
    private let buttonWidth: CGFloat = 297
    private let buttonHeight: CGFloat = 46
    private let buttonCornerRadius: CGFloat = 10
    private let horizontalPadding: CGFloat = 48

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: geometry.size.height * 0.55)

                // Title text - Figma: 36px Semibold, centered
                Text(content.title)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(0)
                    .padding(.horizontal, horizontalPadding)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                // Get Started button - Figma: 297x46, #a4c8e1, shadow
                if content.showGetStartedButton {
                    Button(action: onGetStarted) {
                        Text("Get Started")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: buttonWidth, height: buttonHeight)
                            .background(Color.insuLightBlue)
                            .cornerRadius(buttonCornerRadius)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                    }
                    .padding(.bottom, 12)
                }

                // Login link - Figma: 15px Regular, "Log In" bold
                if content.showLoginLink {
                    Button(action: onLoginTapped) {
                        (Text("Already have an account? Click here to ")
                            .font(.system(size: 15, weight: .regular))
                         +
                         Text("Log In")
                            .font(.system(size: 15, weight: .bold)))
                            .foregroundColor(.black)
                    }
                    .padding(.bottom, 20)
                }

                Spacer()
                    .frame(height: 100)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct InsuCarouselSlideView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            InsuCarouselSlideView(
                content: CarouselSlideContent(
                    title: "Welcome to\nInsu.",
                    showGetStartedButton: true,
                    showLoginLink: true
                ),
                slideIndex: 2,
                onGetStarted: {},
                onLoginTapped: {}
            )
        }
    }
}
#endif
