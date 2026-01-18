//
//  InsuOnboardingColors.swift
//  Loop
//
//  Created for INSU onboarding flow
//

import SwiftUI

// MARK: - Color Extensions (from Figma)

extension Color {
    /// Primary blue color from Figma (#2d5488)
    static let insuPrimaryBlue = Color(red: 0.176, green: 0.329, blue: 0.533)

    /// Light blue button color from Figma (#a4c8e1)
    static let insuLightBlue = Color(red: 0.643, green: 0.784, blue: 0.882)

    /// Gray text color from Figma (#696969)
    static let insuGray = Color(red: 0.412, green: 0.412, blue: 0.412)

    /// Inactive indicator color from Figma (#d9d9d9)
    static let insuInactiveGray = Color(red: 0.851, green: 0.851, blue: 0.851)

    /// Legacy alias for backward compatibility
    static var insuNavyBlue: Color { insuPrimaryBlue }
    static var insuMediumBlue: Color { insuPrimaryBlue.opacity(0.7) }
}

// MARK: - Gradients

struct InsuGradients {
    /// Gradient for splash screen (black to navy)
    static let splashGradient = LinearGradient(
        colors: [Color.black, Color.insuNavyBlue],
        startPoint: .top,
        endPoint: .bottom
    )

    /// Returns the appropriate gradient for each carousel slide
    static func waveGradient(for slideIndex: Int) -> LinearGradient {
        switch slideIndex {
        case 0:
            // Dark navy for first slide
            return LinearGradient(
                colors: [.insuNavyBlue, Color(red: 0.15, green: 0.25, blue: 0.4)],
                startPoint: .top,
                endPoint: .bottom
            )
        case 1:
            // Medium blue for second slide
            return LinearGradient(
                colors: [.insuMediumBlue, .insuLightBlue],
                startPoint: .top,
                endPoint: .bottom
            )
        case 2:
            // Light blue for third slide
            return LinearGradient(
                colors: [.insuLightBlue, Color(red: 0.85, green: 0.91, blue: 0.96)],
                startPoint: .top,
                endPoint: .bottom
            )
        default:
            return LinearGradient(
                colors: [.insuNavyBlue],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

// MARK: - UserDefaults Keys

struct InsuOnboardingKeys {
    static let hasCompletedInitialOnboarding = "com.insu.Loop.hasCompletedInitialOnboarding"
}

// MARK: - UserDefaults Extension

extension UserDefaults {
    var hasCompletedInsuOnboarding: Bool {
        get { bool(forKey: InsuOnboardingKeys.hasCompletedInitialOnboarding) }
        set { set(newValue, forKey: InsuOnboardingKeys.hasCompletedInitialOnboarding) }
    }
}

// MARK: - Notification Names

extension Notification.Name {
    /// Posted when the user requests to log out and return to INSU onboarding
    static let InsuLogoutRequested = Notification.Name("com.insu.Loop.logoutRequested")
}
