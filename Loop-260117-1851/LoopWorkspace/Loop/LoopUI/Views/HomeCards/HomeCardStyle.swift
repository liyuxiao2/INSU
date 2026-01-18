//
//  HomeCardStyle.swift
//  LoopUI
//
//  Created for Loop redesign
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Color Palette (matching Figma design)

public extension Color {
    static let insuBlue = Color(red: 164/255, green: 200/255, blue: 225/255)       // #A4C8E1 - card backgrounds
    static let insuDarkBlue = Color(red: 31/255, green: 60/255, blue: 110/255)     // #1F3C6E - buttons, accents
    static let insuGray = Color(red: 105/255, green: 105/255, blue: 105/255)       // #696969 - secondary text
    static let insuCardWhite = Color.white
    static let insuTextPrimary = Color.black
}

// MARK: - Card Styling

public struct InsuCardModifier: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .background(Color.insuBlue)
            .cornerRadius(20)
    }
}

public struct InsuInnerCardModifier: ViewModifier {
    let hasShadow: Bool

    public init(hasShadow: Bool = false) {
        self.hasShadow = hasShadow
    }

    public func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: hasShadow ? Color.black.opacity(0.25) : .clear, radius: 4, x: 0, y: 4)
    }
}

// MARK: - View Extensions

public extension View {
    func insuCardStyle() -> some View {
        self.modifier(InsuCardModifier())
    }

    func insuInnerCardStyle(hasShadow: Bool = false) -> some View {
        self.modifier(InsuInnerCardModifier(hasShadow: hasShadow))
    }
}

// MARK: - Typography (matching Figma SF Pro fonts)

public struct InsuTypography {
    public static let greeting = Font.system(size: 36, weight: .semibold)
    public static let subtitle = Font.system(size: 16, weight: .regular)
    public static let subtitleBold = Font.system(size: 16, weight: .bold).italic()
    public static let glucoseValue = Font.system(size: 90, weight: .semibold)
    public static let glucoseUnit = Font.system(size: 16, weight: .regular)
    public static let iobLabel = Font.system(size: 16, weight: .regular)
    public static let iobValue = Font.system(size: 16, weight: .bold)
    public static let cardTitle = Font.system(size: 20, weight: .bold)
    public static let cardLargeValue = Font.system(size: 50, weight: .bold)
    public static let cardUnit = Font.system(size: 20, weight: .regular)
    public static let cardDate = Font.system(size: 16, weight: .regular)
    public static let buttonText = Font.system(size: 20, weight: .bold)
}

// MARK: - Spacing

public struct InsuSpacing {
    public static let screenHorizontalPadding: CGFloat = 20
    public static let cardCornerRadius: CGFloat = 20
    public static let innerCardCornerRadius: CGFloat = 15
    public static let mainCardHeight: CGFloat = 234
    public static let smallCardHeight: CGFloat = 258
    public static let smallCardWidth: CGFloat = 171
    public static let buttonHeight: CGFloat = 46
    public static let tabBarHeight: CGFloat = 65
}

// MARK: - Button Styles

public struct InsuPrimaryButtonStyle: ButtonStyle {
    public init() {}

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(InsuTypography.buttonText)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: InsuSpacing.buttonHeight)
            .background(Color.insuDarkBlue)
            .cornerRadius(InsuSpacing.cardCornerRadius)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
    }
}
