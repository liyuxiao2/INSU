//
//  StatsViewModel.swift
//  LoopUI
//
//  Created for Loop redesign - Stats page
//  Copyright © 2026. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

// MARK: - Data Point Model

public struct GlucoseDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let value: Double

    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}

// MARK: - Stats View Model

public class StatsViewModel: ObservableObject {
    // MARK: - User Info
    @Published public var userName: String

    // MARK: - Chart Time Range
    @Published public var selectedHourRange: Int = 24  // 3, 6, 12, 24
    @Published public var selectedDayRange: Int = 7    // 3, 7, 14, 30, 90

    // MARK: - Glucose Data Points for Chart
    @Published public var glucoseData: [GlucoseDataPoint] = []

    // MARK: - Summary Stats
    @Published public var averageGlucose: Double
    @Published public var gmi: Double  // Glucose Management Indicator
    @Published public var glucoseUnit: String
    @Published public var daysOfDataAvailable: Int

    // MARK: - Time in Range Percentages
    @Published public var veryHighPercent: Double
    @Published public var highPercent: Double
    @Published public var inRangePercent: Double
    @Published public var lowPercent: Double
    @Published public var veryLowPercent: Double

    // MARK: - Target Range
    @Published public var targetRangeLow: Double
    @Published public var targetRangeHigh: Double

    // MARK: - Change Indicator
    @Published public var changeFromPriorPeriod: Double?

    // MARK: - Connection State
    @Published public var isPumpConnected: Bool

    // MARK: - Selected Data Point (for interactive chart)
    @Published public var selectedDataPoint: GlucoseDataPoint?

    // MARK: - Refresh Callback
    public var onRefreshNeeded: (() -> Void)?

    // MARK: - Initialization

    public init(isPumpConnected: Bool = false) {
        self.isPumpConnected = isPumpConnected
        self.userName = "User"
        self.averageGlucose = 0.0
        self.gmi = 0.0
        self.glucoseUnit = "mmol/L"
        self.daysOfDataAvailable = 0
        self.veryHighPercent = 0
        self.highPercent = 0
        self.inRangePercent = 0
        self.lowPercent = 0
        self.veryLowPercent = 0
        self.targetRangeLow = 3.9
        self.targetRangeHigh = 10.0

        if !isPumpConnected {
            loadDummyData()
        }
    }

    // MARK: - Load Dummy Data

    public func loadDummyData() {
        userName = "Arian"
        glucoseUnit = "mmol/L"
        averageGlucose = 8.7
        gmi = 7.1
        daysOfDataAvailable = 7

        // Time in Range (from screenshot)
        veryHighPercent = 8
        highPercent = 21
        inRangePercent = 69
        lowPercent = 1
        veryLowPercent = 1  // <1% shown as 1

        // Target Range
        targetRangeLow = 3.9
        targetRangeHigh = 10.0

        // Change indicator
        changeFromPriorPeriod = -5.0

        // Generate dummy glucose data for chart
        generateDummyChartData()
    }

    private func generateDummyChartData() {
        glucoseData = []
        let now = Date()
        let calendar = Calendar.current

        // Generate data points for 24 hours (one point every 15 minutes)
        let pointCount = (selectedHourRange * 60) / 15

        for i in 0..<pointCount {
            let minutesAgo = Double(pointCount - 1 - i) * 15
            let date = calendar.date(byAdding: .minute, value: -Int(minutesAgo), to: now)!

            // Generate values that fluctuate in the range shown in screenshot (~7.5 to 19.0)
            let baseValue = 12.0
            let amplitude = 6.0
            let frequency = Double(i) / Double(pointCount) * 8 * .pi
            let noise = Double.random(in: -1.5...1.5)
            let value = baseValue + amplitude * sin(frequency) * 0.5 + noise

            // Clamp to realistic range
            let clampedValue = max(4.0, min(22.0, value))

            glucoseData.append(GlucoseDataPoint(date: date, value: clampedValue))
        }
    }

    // MARK: - Update Methods

    public func updateHourRange(_ hours: Int) {
        selectedHourRange = hours
        if !isPumpConnected {
            generateDummyChartData()
        } else {
            // Trigger refresh from real data
            onRefreshNeeded?()
        }
    }

    public func updateDayRange(_ days: Int) {
        selectedDayRange = days
        // Update summary stats based on selected range
        if !isPumpConnected {
            // Adjust dummy data slightly for different ranges
            daysOfDataAvailable = min(days, 7)
        } else {
            // Trigger refresh from real data
            onRefreshNeeded?()
        }
    }

    public func updateUserName(_ name: String) {
        DispatchQueue.main.async {
            self.userName = name
        }
    }

    // MARK: - Real Data Update Methods

    public func updateGlucoseData(_ dataPoints: [GlucoseDataPoint]) {
        DispatchQueue.main.async {
            self.glucoseData = dataPoints
        }
    }

    public func updateGlucoseUnit(_ unit: String) {
        DispatchQueue.main.async {
            self.glucoseUnit = unit
        }
    }

    public func updateAverageGlucose(_ average: Double) {
        DispatchQueue.main.async {
            self.averageGlucose = average
        }
    }

    public func updateGMI(_ gmiValue: Double) {
        DispatchQueue.main.async {
            self.gmi = gmiValue
        }
    }

    public func updateTimeInRange(veryHigh: Double, high: Double, inRange: Double, low: Double, veryLow: Double) {
        DispatchQueue.main.async {
            self.veryHighPercent = veryHigh
            self.highPercent = high
            self.inRangePercent = inRange
            self.lowPercent = low
            self.veryLowPercent = veryLow
        }
    }

    public func updateTargetRange(low: Double, high: Double) {
        DispatchQueue.main.async {
            self.targetRangeLow = low
            self.targetRangeHigh = high
        }
    }

    public func updateDaysAvailable(_ days: Int) {
        DispatchQueue.main.async {
            self.daysOfDataAvailable = days
        }
    }

    // MARK: - Computed Properties

    public var hourRangeOptions: [Int] {
        [3, 6, 12, 24]
    }

    public var dayRangeOptions: [Int] {
        [3, 7, 14, 30, 90]
    }

    public var summaryTitle: String {
        "\(selectedDayRange)-Day Glucose Summary"
    }

    public var dataAvailabilityText: String {
        if daysOfDataAvailable < selectedDayRange {
            return "Only \(daysOfDataAvailable) days of data available"
        }
        return ""
    }

    public var targetRangeText: String {
        String(format: "%.1f - %.1f %@", targetRangeLow, targetRangeHigh, glucoseUnit)
    }

    public var changeText: String? {
        guard let change = changeFromPriorPeriod else { return nil }
        let prefix = change >= 0 ? "+" : ""
        return "~\(prefix)\(Int(change))% change since prior \(selectedDayRange) day period"
    }
}
