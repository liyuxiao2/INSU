//
//  DashboardCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct DashboardCardView: View {
    let glucoseValue: Double
    let glucoseUnit: String
    let iobValue: Double
    let iobUnit: String
    let trendArrow: String?
    let isStale: Bool

    public init(glucoseValue: Double, glucoseUnit: String, iobValue: Double, iobUnit: String, trendArrow: String?, isStale: Bool) {
        self.glucoseValue = glucoseValue
        self.glucoseUnit = glucoseUnit
        self.iobValue = iobValue
        self.iobUnit = iobUnit
        self.trendArrow = trendArrow
        self.isStale = isStale
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

                // Glucose value with trend arrow
                HStack(alignment: .center, spacing: 12) {
                    Text(formatGlucose(glucoseValue))
                        .font(InsuTypography.glucoseValue)
                        .foregroundColor(isStale ? Color.insuGray : Color.insuTextPrimary)

                    if let arrow = trendArrow {
                        Image(systemName: trendIconName(for: arrow))
                            .font(.system(size: 40, weight: .bold))
                            .foregroundColor(isStale ? Color.insuGray : Color.insuTextPrimary)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.insuTextPrimary, lineWidth: 2)
                            )
                    }
                }

                // Unit label
                Text(glucoseUnit)
                    .font(InsuTypography.glucoseUnit)
                    .foregroundColor(Color.insuGray)
                    .padding(.top, 8)

                Spacer()
            }
            .padding(7)
            .background(Color.white)
            .cornerRadius(InsuSpacing.innerCardCornerRadius)
            .padding(7)
        }
        .frame(height: InsuSpacing.mainCardHeight)
    }

    private func formatGlucose(_ value: Double) -> String {
        if value == 0 {
            return "---"
        }
        return String(format: "%.2f", value)
    }

    private func trendIconName(for arrow: String) -> String {
        switch arrow {
        case "↑", "⬆️": return "arrow.up"
        case "↗", "⬈": return "arrow.up.right"
        case "→", "➡️": return "arrow.right"
        case "↘", "⬊": return "arrow.down.right"
        case "↓", "⬇️": return "arrow.down"
        default: return "arrow.up.right"
        }
    }
}

// MARK: - Preview

struct DashboardCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DashboardCardView(
                glucoseValue: 7.00,
                glucoseUnit: "mmol/L",
                iobValue: 2.05,
                iobUnit: "U",
                trendArrow: "↗",
                isStale: false
            )
            .padding(.horizontal, 20)
        }
        .background(Color.white)
        .previewDisplayName("Figma Design Match")
    }
}
