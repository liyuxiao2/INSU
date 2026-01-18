//
//  PodStatusCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page 2" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct PodStatusCardView: View {
    let reservoirLevel: Double
    let reservoirUnit: String
    let iobValue: Double
    let iobUnit: String
    let onViewDetails: () -> Void

    public init(reservoirLevel: Double, reservoirUnit: String, iobValue: Double, iobUnit: String, onViewDetails: @escaping () -> Void) {
        self.reservoirLevel = reservoirLevel
        self.reservoirUnit = reservoirUnit
        self.iobValue = iobValue
        self.iobUnit = iobUnit
        self.onViewDetails = onViewDetails
    }

    public var body: some View {
        ZStack {
            // Outer blue card
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                .fill(Color.insuBlue)

            // Inner white card
            VStack(spacing: 0) {
                // IOB and Reservoir header bar with shadow
                HStack {
                    Text("IOB ")
                        .font(InsuTypography.iobLabel)
                        .foregroundColor(Color.insuGray)
                    + Text(String(format: "%.2f", iobValue) + " " + iobUnit)
                        .font(InsuTypography.iobValue)
                        .foregroundColor(Color.insuGray)

                    Spacer()

                    Text(String(format: "%.0f", reservoirLevel) + " ")
                        .font(InsuTypography.iobValue)
                        .foregroundColor(Color.insuGray)
                    + Text(reservoirUnit + " Left")
                        .font(InsuTypography.iobLabel)
                        .foregroundColor(Color.insuGray)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(InsuSpacing.innerCardCornerRadius)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                Spacer()

                // Pod Expires info
                Text("Pod Expires: Tomorrow")
                    .font(InsuTypography.cardDate)
                    .foregroundColor(Color.insuGray)

                Text("Jan 18 (2:29 PM)")
                    .font(InsuTypography.cardDate)
                    .foregroundColor(Color.insuGray)
                    .padding(.top, 2)

                Spacer()

                // View Pod Details button - smaller
                Button(action: onViewDetails) {
                    Text("View Pod Details")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color.insuDarkBlue)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 12)
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

struct PodStatusCardView_Previews: PreviewProvider {
    static var previews: some View {
        PodStatusCardView(
            reservoirLevel: 40,
            reservoirUnit: "U",
            iobValue: 2.05,
            iobUnit: "U",
            onViewDetails: {}
        )
        .padding(.horizontal, 20)
        .previewDisplayName("Figma Design Match")
    }
}
