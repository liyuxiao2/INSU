//
//  SettingsTabView.swift
//  LoopUI
//
//  Created for Loop redesign - Settings tab wrapper
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct SettingsTabView<Content: View>: View {
    let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 0) {
                // Settings title header
                HStack {
                    Text("Settings")
                        .font(InsuTypography.greeting)
                        .foregroundColor(Color.insuTextPrimary)
                    Spacer()
                }
                .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                .padding(.top, 60) // Account for safe area

                // Settings content
                content
                    .padding(.bottom, InsuSpacing.tabBarHeight + 20)
            }
        }
    }
}
