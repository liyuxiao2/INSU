//
//  HomeViewModel.swift
//  LoopUI
//
//  Created for Loop redesign
//  Copyright © 2026. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import HealthKit
import LoopKit

public class HomeViewModel: ObservableObject {
    // MARK: - Published Properties

    @Published public var userName: String
    @Published var glucoseValue: Double
    @Published var glucoseUnit: String
    @Published var trendArrow: String?
    @Published var isGlucoseStale: Bool
    @Published var iobValue: Double
    @Published var iobUnit: String
    @Published var reservoirLevel: Double
    @Published var reservoirUnit: String
    @Published var modeName: String
    @Published var isAutomatedMode: Bool
    @Published var lastBolusValue: Double
    @Published var lastBolusUnit: String
    @Published var lastBolusDate: String
    @Published var isInsulinSuspended: Bool
    @Published var isWorkoutActive: Bool

    // MARK: - Initialization

    public init(
        userName: String = "Arian",
        glucoseValue: Double = 0.0,
        glucoseUnit: String = "mmol/L",
        trendArrow: String? = nil,
        isGlucoseStale: Bool = false,
        iobValue: Double = 0.0,
        iobUnit: String = "U",
        reservoirLevel: Double = 0.0,
        reservoirUnit: String = "U",
        modeName: String = "Manual",
        isAutomatedMode: Bool = false,
        lastBolusValue: Double = 0.0,
        lastBolusUnit: String = "Units",
        lastBolusDate: String = "--",
        isInsulinSuspended: Bool = false,
        isWorkoutActive: Bool = false
    ) {
        self.userName = userName
        self.glucoseValue = glucoseValue
        self.glucoseUnit = glucoseUnit
        self.trendArrow = trendArrow
        self.isGlucoseStale = isGlucoseStale
        self.iobValue = iobValue
        self.iobUnit = iobUnit
        self.reservoirLevel = reservoirLevel
        self.reservoirUnit = reservoirUnit
        self.modeName = modeName
        self.isAutomatedMode = isAutomatedMode
        self.lastBolusValue = lastBolusValue
        self.lastBolusUnit = lastBolusUnit
        self.lastBolusDate = lastBolusDate
        self.isInsulinSuspended = isInsulinSuspended
        self.isWorkoutActive = isWorkoutActive
    }

    // MARK: - Update Methods

    public func updateGlucose(value: Double, unit: HKUnit, trend: GlucoseTrend?, isStale: Bool) {
        DispatchQueue.main.async {
            self.glucoseValue = value
            self.glucoseUnit = unit.shortLocalizedUnitString()
            self.trendArrow = trend?.symbol
            self.isGlucoseStale = isStale
        }
    }

    public func updateIOB(value: Double) {
        DispatchQueue.main.async {
            self.iobValue = value
        }
    }

    public func updateReservoir(level: Double) {
        DispatchQueue.main.async {
            self.reservoirLevel = level
        }
    }

    public func updateMode(name: String, isAutomated: Bool) {
        DispatchQueue.main.async {
            self.modeName = name
            self.isAutomatedMode = isAutomated
        }
    }

    public func updateUserName(_ name: String) {
        DispatchQueue.main.async {
            self.userName = name
        }
    }

    public func updateSuspendedState(_ isSuspended: Bool) {
        DispatchQueue.main.async {
            self.isInsulinSuspended = isSuspended
        }
    }

    public func updateWorkoutState(_ isActive: Bool) {
        DispatchQueue.main.async {
            self.isWorkoutActive = isActive
        }
    }
}

// MARK: - HKUnit Extension

extension HKUnit {
    func shortLocalizedUnitString() -> String {
        if self == .milligramsPerDeciliter {
            return "mg/dL"
        } else if self == .millimolesPerLiter {
            return "mmol/L"
        }
        return localizedShortUnitString
    }
}
