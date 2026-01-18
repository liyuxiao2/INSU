//
//  InsuBolusViewModelAdapter.swift
//  Loop
//
//  Adapter that wraps SimpleBolusViewModel to work with InsuBolusFlowView
//  Copyright © 2026. All rights reserved.
//

import SwiftUI
import LoopUI
import LoopKit
import LoopKitUI
import HealthKit
import Combine

/// Adapter that wraps SimpleBolusViewModel to conform to InsuBolusViewModelProtocol
/// This allows the new INSU bolus UI to use the existing Loop bolus logic
class InsuBolusViewModelAdapter: ObservableObject, InsuBolusViewModelProtocol {
    private let simpleViewModel: SimpleBolusViewModel
    private let displayGlucosePreference: DisplayGlucosePreference
    private let latestGlucose: (() -> HKQuantity?)?
    private var cancellables = Set<AnyCancellable>()

    init(
        simpleViewModel: SimpleBolusViewModel,
        displayGlucosePreference: DisplayGlucosePreference,
        latestGlucose: (() -> HKQuantity?)? = nil
    ) {
        self.simpleViewModel = simpleViewModel
        self.displayGlucosePreference = displayGlucosePreference
        self.latestGlucose = latestGlucose

        // Forward objectWillChange from the wrapped view model
        simpleViewModel.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }

    // MARK: - InsuBolusViewModelProtocol

    var carbsString: String {
        get { simpleViewModel.enteredCarbString }
        set {
            objectWillChange.send()
            simpleViewModel.enteredCarbString = newValue
        }
    }

    var glucoseString: String {
        get { simpleViewModel.manualGlucoseString }
        set {
            objectWillChange.send()
            simpleViewModel.manualGlucoseString = newValue
        }
    }

    var recommendedBolusString: String {
        simpleViewModel.recommendedBolus
    }

    var iobString: String {
        if let activeInsulin = simpleViewModel.activeInsulin {
            return "\(activeInsulin) U"
        }
        return "0 U"
    }

    var mealBolusString: String {
        // The meal bolus is approximated from the recommendation when carbs are entered
        // This is a display-only value
        if !simpleViewModel.enteredCarbString.isEmpty,
           let carbs = Double(simpleViewModel.enteredCarbString),
           carbs > 0 {
            return "\(simpleViewModel.recommendedBolus) U"
        }
        return "0 U"
    }

    var correctionBolusString: String {
        // Correction bolus is shown when glucose is entered without carbs
        // This is a display-only value
        return "0 U"
    }

    func useSensorGlucose() {
        if let latestGlucose = latestGlucose?() {
            let glucoseValueString = displayGlucosePreference.format(latestGlucose, includeUnit: false)
            glucoseString = glucoseValueString
        }
    }

    func deliverBolus(completion: @escaping (Bool) -> Void) {
        simpleViewModel.saveAndDeliver(completion: completion)
    }
}
