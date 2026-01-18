//
//  GlucoseSummaryCard.swift
//  LoopUI
//
//  Created for Loop redesign - Stats page glucose summary
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct GlucoseSummaryCard: View {
    @ObservedObject var viewModel: StatsViewModel

    public init(viewModel: StatsViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            // Outer blue card
            RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                .fill(Color.insuBlue)

            VStack(alignment: .leading, spacing: 12) {
                // Day range selector
                DayRangeSelector(
                    options: viewModel.dayRangeOptions,
                    selected: viewModel.selectedDayRange,
                    onSelect: { viewModel.updateDayRange($0) }
                )

                // Summary title
                Text(viewModel.summaryTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.insuTextPrimary)

                // Data availability note
                if !viewModel.dataAvailabilityText.isEmpty {
                    Text(viewModel.dataAvailabilityText)
                        .font(.system(size: 14))
                        .foregroundColor(Color.insuGray)
                }

                // Stats display
                VStack(alignment: .leading, spacing: 8) {
                    // Average Glucose
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(String(format: "%.1f", viewModel.averageGlucose))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color.insuTextPrimary)

                        Text("Average Glucose (\(viewModel.glucoseUnit))")
                            .font(.system(size: 14))
                            .foregroundColor(Color.insuGray)
                    }

                    // GMI
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text(String(format: "%.1f", viewModel.gmi))
                            .font(.system(size: 48, weight: .bold))
                            .foregroundColor(Color.insuTextPrimary)

                        Text("GMI (%)")
                            .font(.system(size: 14))
                            .foregroundColor(Color.insuGray)
                    }
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

// MARK: - Day Range Selector

struct DayRangeSelector: View {
    let options: [Int]
    let selected: Int
    let onSelect: (Int) -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: InsuSpacing.innerCardCornerRadius)
                .fill(Color.insuBlue.opacity(0.3))

            HStack(spacing: 0) {
                ForEach(options, id: \.self) { option in
                    Button(action: { onSelect(option) }) {
                        Text(option == selected ? "\(option) Days" : "\(option)")
                            .font(.system(size: 14, weight: selected == option ? .bold : .regular))
                            .foregroundColor(Color.insuTextPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                selected == option ?
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white)
                                        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
                                    : nil
                            )
                    }
                }
            }
            .padding(4)
        }
        .frame(height: 40)
    }
}

// MARK: - Preview

struct GlucoseSummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StatsViewModel(isPumpConnected: false)
        GlucoseSummaryCard(viewModel: viewModel)
            .padding(.horizontal, 20)
            .previewLayout(.sizeThatFits)
    }
}
