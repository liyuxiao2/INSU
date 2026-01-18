//
//  InsuWaveBackgroundView.swift
//  Loop
//
//  Created for INSU onboarding flow
//

import SwiftUI

// MARK: - Wave Shape

struct WaveShape: Shape {
    var yOffset: CGFloat
    var waveHeight: CGFloat = 50

    var animatableData: CGFloat {
        get { yOffset }
        set { yOffset = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Start from top-left
        let startY = rect.height * 0.4 + yOffset

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: startY))

        // Create smooth wave curve
        path.addCurve(
            to: CGPoint(x: rect.width, y: startY - 20),
            control1: CGPoint(x: rect.width * 0.3, y: startY + waveHeight),
            control2: CGPoint(x: rect.width * 0.7, y: startY - waveHeight)
        )

        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()

        return path
    }
}

// MARK: - Wave Background View

struct InsuWaveBackgroundView: View {
    let slideIndex: Int
    @State private var waveOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // White background
                Color.white
                    .ignoresSafeArea()

                // Wave shape with gradient
                WaveShape(yOffset: waveOffset)
                    .fill(InsuGradients.waveGradient(for: slideIndex))
                    .ignoresSafeArea()
            }
        }
        .onAppear {
            // Subtle wave animation
            withAnimation(
                .easeInOut(duration: 3)
                .repeatForever(autoreverses: true)
            ) {
                waveOffset = 15
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct InsuWaveBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InsuWaveBackgroundView(slideIndex: 0)
                .previewDisplayName("Slide 0 - Navy")

            InsuWaveBackgroundView(slideIndex: 1)
                .previewDisplayName("Slide 1 - Medium Blue")

            InsuWaveBackgroundView(slideIndex: 2)
                .previewDisplayName("Slide 2 - Light Blue")
        }
    }
}
#endif
