//
//  SensorAnalyticsCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page (analytics)" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct SensorAnalyticsCardView: View {
    let averageGlucose: Double
    let glucoseUnit: String
    let gmiPercentage: Double
    let timeInRangePercentage: Double
    let timeHighPercentage: Double
    let timeVeryHighPercentage: Double
    let timeLowPercentage: Double
    let timeVeryLowPercentage: Double
    let targetRangeMin: Double
    let targetRangeMax: Double
    let dataAvailableDays: Int
    let glucoseTrendChange: String

    public init(
        averageGlucose: Double = 8.7,
        glucoseUnit: String = "mmol/L",
        gmiPercentage: Double = 7.1,
        timeInRangePercentage: Double = 69,
        timeHighPercentage: Double = 21,
        timeVeryHighPercentage: Double = 8,
        timeLowPercentage: Double = 1,
        timeVeryLowPercentage: Double = 0.5,
        targetRangeMin: Double = 3.9,
        targetRangeMax: Double = 10.0,
        dataAvailableDays: Int = 7,
        glucoseTrendChange: String = "~5% change since prior 7 day period"
    ) {
        self.averageGlucose = averageGlucose
        self.glucoseUnit = glucoseUnit
        self.gmiPercentage = gmiPercentage
        self.timeInRangePercentage = timeInRangePercentage
        self.timeHighPercentage = timeHighPercentage
        self.timeVeryHighPercentage = timeVeryHighPercentage
        self.timeLowPercentage = timeLowPercentage
        self.timeVeryLowPercentage = timeVeryLowPercentage
        self.targetRangeMin = targetRangeMin
        self.targetRangeMax = targetRangeMax
        self.dataAvailableDays = dataAvailableDays
        self.glucoseTrendChange = glucoseTrendChange
    }

    public var body: some View {
        VStack(spacing: 12) {
            // Glucose Chart Section
            glucoseChartSection

            Divider()
                .frame(height: 1)
                .background(Color.insuGray.opacity(0.2))
                .padding(.vertical, 4)

            // 7-Day Summary Section
            sevenDaySummarySection

            Divider()
                .frame(height: 1)
                .background(Color.insuGray.opacity(0.2))
                .padding(.vertical, 4)

            // Time in Range Section
            timeInRangeSection
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(InsuSpacing.cardCornerRadius)
        .padding(7)
        .background(Color.insuBlue)
        .cornerRadius(InsuSpacing.cardCornerRadius)
        .frame(height: InsuSpacing.mainCardHeight)
    }

    private var glucoseChartSection: some View {
        VStack(spacing: 8) {
            // Time period selector
            HStack(spacing: 8) {
                ForEach(["3", "6", "12", "24 Hours"], id: \.self) { period in
                    Button(action: {}) {
                        Text(period)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(period == "24 Hours" ? Color.white : Color.insuTextPrimary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(period == "24 Hours" ? Color.insuDarkBlue : Color.insuGray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            .frame(height: 32)

            // Placeholder for glucose chart
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 1.0, green: 0.85, blue: 0.2).opacity(0.3),
                        Color(red: 1.0, green: 0.85, blue: 0.2).opacity(0.1)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(8)

                VStack(alignment: .center) {
                    HStack(spacing: 20) {
                        VStack(alignment: .center, spacing: 4) {
                            Text("8AM")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(Color.insuGray)
                            Text("4PM")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(Color.insuGray)
                            Text("Now")
                                .font(.system(size: 11, weight: .regular))
                                .foregroundColor(Color.insuGray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.bottom, 8)
                }
            }
            .frame(height: 110)
        }
    }

    private var sevenDaySummarySection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("7-Day Glucose Summary")
                    .font(InsuTypography.cardTitle)
                    .foregroundColor(Color.insuTextPrimary)
                Spacer()
            }

            Text("Only \(dataAvailableDays) days of data available")
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color.insuGray)

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(String(format: "%.1f", averageGlucose))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.insuTextPrimary)
                    Text("Average Glucose (\(glucoseUnit))")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color.insuGray)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(String(format: "%.1f", gmiPercentage))
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(Color.insuTextPrimary)
                    Text("GMI (%)")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(Color.insuGray)
                }
            }
        }
    }

    private var timeInRangeSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Time in Range")
                    .font(InsuTypography.cardTitle)
                    .foregroundColor(Color.insuTextPrimary)
                Spacer()
                Text("Target Range\n\(String(format: "%.1f", targetRangeMin)) - \(String(format: "%.1f", targetRangeMax)) mmol/L")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color.insuGray)
                    .multilineTextAlignment(.trailing)
            }

            // Time in range breakdown
            VStack(spacing: 8) {
                timeInRangeRow(label: "Very High", percentage: timeVeryHighPercentage, color: Color(red: 1.0, green: 0.2, blue: 0.2))
                timeInRangeRow(label: "High", percentage: timeHighPercentage, color: Color(red: 1.0, green: 0.6, blue: 0.2))
                timeInRangeRow(label: "In Range", percentage: timeInRangePercentage, color: Color(red: 0.2, green: 0.8, blue: 0.2))
                timeInRangeRow(label: "Low", percentage: timeLowPercentage, color: Color(red: 1.0, green: 0.85, blue: 0.2))
                timeInRangeRow(label: "Very Low", percentage: timeVeryLowPercentage, color: Color(red: 0.8, green: 0.2, blue: 0.8))
            }

            Text(glucoseTrendChange)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(Color.insuGray)
                .lineLimit(3)
        }
    }

    private func timeInRangeRow(label: String, percentage: Double, color: Color) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(color)
                .frame(width: 16, height: 16)

            Text(label)
                .font(.system(size: 12, weight: .regular))
                .foregroundColor(Color.insuTextPrimary)

            Spacer()

            Text(String(format: "%.0f", percentage) + "%")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(Color.insuTextPrimary)
        }
    }
}

// MARK: - Preview

struct SensorAnalyticsCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SensorAnalyticsCardView()
                .padding(.horizontal, 20)
        }
        .background(Color.white)
        .previewDisplayName("Figma Design Match")
    }
}
