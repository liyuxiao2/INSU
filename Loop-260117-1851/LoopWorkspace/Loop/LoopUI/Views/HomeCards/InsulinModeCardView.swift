//
//  InsulinModeCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page 3" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct InsulinModeCardView: View {
    let modeName: String
    let iobValue: Double
    let iobUnit: String
    let isAutomated: Bool
    let onChangeMode: () -> Void

    public init(modeName: String, iobValue: Double, iobUnit: String, isAutomated: Bool, onChangeMode: @escaping () -> Void) {
        self.modeName = modeName
        self.iobValue = iobValue
        self.iobUnit = iobUnit
        self.isAutomated = isAutomated
        self.onChangeMode = onChangeMode
    }

    public var body: some View {
        ZStack {
            // Outer blue card
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                .fill(Color.insuBlue)

            // Inner white card
            VStack(spacing: 0) {
                // IOB header bar with shadow
                HStack {
                    Text("IOB ")
                        .font(InsuTypography.iobLabel)
                        .foregroundColor(Color.insuGray)
                    + Text(String(format: "%.2f", iobValue) + " " + iobUnit)
                        .font(InsuTypography.iobValue)
                        .foregroundColor(Color.insuGray)

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(InsuSpacing.innerCardCornerRadius)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                Spacer()

                // Mode label
                Text("Active Mode: \(modeName)")
                    .font(InsuTypography.cardDate)
                    .foregroundColor(Color.insuGray)

                // Mode icon
                Image(systemName: isAutomated ? "arrow.triangle.2.circlepath.circle.fill" : "hand.raised.circle.fill")
                    .font(.system(size: 88))
                    .foregroundColor(Color.insuDarkBlue)
                    .padding(.vertical, 16)

                Spacer()

                // Change Mode button
                Button(action: onChangeMode) {
                    Text("Change Mode")
                        .font(InsuTypography.cardDate)
                        .foregroundColor(Color.insuTextPrimary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.insuGray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 16)
            }
            .padding(7)
            .background(Color.white)
            .cornerRadius(InsuSpacing.innerCardCornerRadius)
            .padding(7)
        }
        .frame(height: InsuSpacing.mainCardHeight)
    }
}

// MARK: - Preview

struct InsulinModeCardView_Previews: PreviewProvider {
    static var previews: some View {
        InsulinModeCardView(
            modeName: "Automated",
            iobValue: 2.05,
            iobUnit: "U",
            isAutomated: true,
            onChangeMode: {}
        )
        .padding(.horizontal, 20)
        .previewDisplayName("Figma Design Match")
    }
}
