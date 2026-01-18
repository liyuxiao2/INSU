//
//  InsuSplashView.swift
//  Loop
//
//  Created for INSU onboarding flow
//

import SwiftUI

struct InsuSplashView: View {
    @State private var logoOpacity: Double = 0
    @State private var logoScale: CGFloat = 0.8
    @State private var isPulsing = false

    var onComplete: () -> Void

    var body: some View {
        ZStack {
            // Gradient background (black to navy)
            InsuGradients.splashGradient
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // INSU Logo from Assets
                ZStack {
                    // Pulse ring effect
                    Circle()
                        .fill(Color.insuLightBlue.opacity(0.1))
                        .frame(width: 320, height: 320)
                        .scaleEffect(isPulsing ? 1.3 : 1.0)
                        .opacity(isPulsing ? 0.3 : 0.6)

                    // Actual logo image
                    Image("Insu")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 260, height: 260)
                }
                .opacity(logoOpacity)
                .scaleEffect(logoScale)
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Fade in and scale up
        withAnimation(.easeOut(duration: 0.8)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }

        // Start pulse animation after fade in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(
                .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
            ) {
                isPulsing = true
            }
        }

        // Auto-transition to carousel after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            onComplete()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct InsuSplashView_Previews: PreviewProvider {
    static var previews: some View {
        InsuSplashView(onComplete: {})
    }
}
#endif
