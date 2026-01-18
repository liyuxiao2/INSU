//
//  LastBolusCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct LastBolusCardView: View {
    let bolusValue: Double
    let bolusUnit: String
    let dateString: String

    public init(bolusValue: Double, bolusUnit: String = "Units", dateString: String) {
        self.bolusValue = bolusValue
        self.bolusUnit = bolusUnit
        self.dateString = dateString
    }

    public var body: some View {
        ZStack {
            // Outer blue card
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                .fill(Color.insuBlue)

            // Inner white card
            VStack(spacing: 0) {
                // Title bar with shadow
                HStack {
                    Text("Last Bolus")
                        .font(InsuTypography.cardTitle)
                        .foregroundColor(Color.insuTextPrimary)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(InsuSpacing.innerCardCornerRadius)
                .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 4)

                Spacer()

                // Bolus value
                VStack(spacing: 4) {
                    Text(String(format: "%.2f", bolusValue))
                        .font(InsuTypography.cardLargeValue)
                        .foregroundColor(Color.insuTextPrimary)

                    Text(bolusUnit)
                        .font(InsuTypography.cardUnit)
                        .foregroundColor(Color.insuGray)
                }

                Spacer()

                // Date
                Text(dateString)
                    .font(InsuTypography.cardDate)
                    .foregroundColor(Color.insuGray)
                    .padding(.bottom, 16)
            }
            .padding(6)
            .background(Color.white)
            .cornerRadius(InsuSpacing.innerCardCornerRadius)
            .padding(6)
        }
    }
}

// MARK: - Preview

struct LastBolusCardView_Previews: PreviewProvider {
    static var previews: some View {
        LastBolusCardView(
            bolusValue: 4.15,
            bolusUnit: "Units",
            dateString: "Jan 17 (4:19PM)"
        )
        .frame(width: 171, height: 258)
        .padding()
        .previewDisplayName("Figma Design Match")
    }
}
