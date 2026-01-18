//
//  TimeInRangeCard.swift
//  LoopUI
//
//  Created for Loop redesign - Stats page time in range
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct TimeInRangeCard: View {
    @ObservedObject var viewModel: StatsViewModel

    // Colors for each range (matching screenshot)
    private let veryHighColor = Color(red: 255/255, green: 165/255, blue: 0/255)  // Orange
    private let highColor = Color(red: 255/255, green: 200/255, blue: 0/255)      // Yellow-orange
    private let inRangeColor = Color(red: 34/255, green: 139/255, blue: 34/255)   // Green
    private let lowColor = Color(red: 255/255, green: 99/255, blue: 71/255)       // Tomato red
    private let veryLowColor = Color(red: 220/255, green: 20/255, blue: 60/255)   // Crimson

    public init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Outer blue card
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                .fill(Color.insuBlue)

            VStack(alignment: .leading, spacing: 16) {
                // Title
                Text("Time in Range")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.insuTextPrimary)

                // Content - Bar and Legend side by side
                HStack(alignment: .top, spacing: 16) {
                    // Stacked bar (vertical)
                    StackedBar(
                        veryHighPercent: viewModel.veryHighPercent,
                        highPercent: viewModel.highPercent,
                        inRangePercent: viewModel.inRangePercent,
                        lowPercent: viewModel.lowPercent,
                        veryLowPercent: viewModel.veryLowPercent,
                        veryHighColor: veryHighColor,
                        highColor: highColor,
                        inRangeColor: inRangeColor,
                        lowColor: lowColor,
                        veryLowColor: veryLowColor
                    )
                    .frame(width: 60)

                    // Legend and values
                    VStack(alignment: .leading, spacing: 6) {
                        LegendRow(color: veryHighColor, label: "\(Int(viewModel.veryHighPercent))% Very High")
                        LegendRow(color: highColor, label: "\(Int(viewModel.highPercent))% High")
                        LegendRow(color: inRangeColor, label: "\(Int(viewModel.inRangePercent))% In Range", isBold: true)
                        LegendRow(color: lowColor, label: "\(Int(viewModel.lowPercent))% Low")
                        LegendRow(color: veryLowColor, label: viewModel.veryLowPercent < 1 ? "<1% Very Low" : "\(Int(viewModel.veryLowPercent))% Very Low")
                    }

                    Spacer()

                    // Target Range info
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Target Range")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color.insuTextPrimary)

                        Text(viewModel.targetRangeText)
                            .font(.system(size: 14))
                            .foregroundColor(Color.insuGray)
                    }
                }

                // Change indicator
                if let changeText = viewModel.changeText {
                    Text(changeText)
                        .font(.system(size: 12))
                        .foregroundColor(Color.insuGray)
                        .padding(.top, 4)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
            .cornerRadius(InsuSpacing.innerCardCornerRadius)
            .padding(7)
        }
    }
}

// MARK: - Stacked Bar

struct StackedBar: View {
    let veryHighPercent: Double
    let highPercent: Double
    let inRangePercent: Double
    let lowPercent: Double
    let veryLowPercent: Double

    let veryHighColor: Color
    let highColor: Color
    let inRangeColor: Color
    let lowColor: Color
    let veryLowColor: Color

    var body: some View {
        GeometryReader { geometry in
            let height = geometry.size.height
            let total = veryHighPercent + highPercent + inRangePercent + lowPercent + veryLowPercent

            VStack(spacing: 0) {
                // Very High (top)
                Rectangle()
                    .fill(veryHighColor)
                    .frame(height: height * CGFloat(veryHighPercent / total))

                // High
                Rectangle()
                    .fill(highColor)
                    .frame(height: height * CGFloat(highPercent / total))

                // In Range
                Rectangle()
                    .fill(inRangeColor)
                    .frame(height: height * CGFloat(inRangePercent / total))

                // Low
                Rectangle()
                    .fill(lowColor)
                    .frame(height: height * CGFloat(lowPercent / total))

                // Very Low (bottom)
                Rectangle()
                    .fill(veryLowColor)
                    .frame(height: height * CGFloat(veryLowPercent / total))
            }
            .cornerRadius(8)
        }
    }
}

// MARK: - Legend Row

struct LegendRow: View {
    let color: Color
    let label: String
    var isBold: Bool = false

    var body: some View {
        HStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(width: 20, height: 14)
                .cornerRadius(2)

            Text(label)
                .font(.system(size: 14, weight: isBold ? .bold : .regular))
                .foregroundColor(Color.insuTextPrimary)
        }
    }
}

// MARK: - Preview

struct TimeInRangeCard_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StatsViewModel(isPumpConnected: false)
        TimeInRangeCard(viewModel: viewModel)
            .padding(.horizontal, 20)
            .frame(height: 280)
            .previewLayout(.sizeThatFits)
    }
}
