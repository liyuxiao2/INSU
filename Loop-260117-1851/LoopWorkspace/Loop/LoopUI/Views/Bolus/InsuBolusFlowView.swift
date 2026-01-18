//
//  InsuBolusFlowView.swift
//  LoopUI
//
//  Created for Loop redesign - Main bolus flow coordinator
//  Copyright © 2026. All rights reserved.
//

import SwiftUI
import LoopKit

/// Main coordinator view for the bolus flow
/// Manages navigation between Input (Step 1) and Confirm (Step 2) screens
public struct InsuBolusFlowView<ViewModel: InsuBolusViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModel

    @State private var currentStep: BolusFlowStep = .input

    let userName: String
    let glucoseUnit: String
    let onDismiss: () -> Void

    public init(
        viewModel: ViewModel,
        userName: String,
        glucoseUnit: String,
        onDismiss: @escaping () -> Void
    ) {
        self.viewModel = viewModel
        self.userName = userName
        self.glucoseUnit = glucoseUnit
        self.onDismiss = onDismiss
    }

    public var body: some View {
        ZStack {
            Color.insuBlue.edgesIgnoringSafeArea(.bottom)

            switch currentStep {
            case .input:
                InsuBolusInputView(
                    userName: userName,
                    carbsValue: $viewModel.carbsString,
                    glucoseValue: $viewModel.glucoseString,
                    glucoseUnit: glucoseUnit,
                    totalBolus: viewModel.recommendedBolusString,
                    iobValue: viewModel.iobString,
                    mealBolus: viewModel.mealBolusString,
                    correctionBolus: viewModel.correctionBolusString,
                    onCustomFoods: {
                        // TODO: Present custom foods picker
                    },
                    onUseSensor: {
                        viewModel.useSensorGlucose()
                    },
                    onCalculations: {
                        // TODO: Show calculations breakdown
                    },
                    onConfirm: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentStep = .confirm
                        }
                    },
                    onCancel: {
                        onDismiss()
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .leading),
                    removal: .move(edge: .leading)
                ))

            case .confirm:
                InsuBolusConfirmView(
                    userName: userName,
                    carbsValue: formatCarbsForSummary(),
                    glucoseValue: viewModel.glucoseString,
                    glucoseUnit: glucoseUnit,
                    bolusNowPercent: "100%",
                    mealBolusValue: viewModel.mealBolusString,
                    totalBolus: viewModel.recommendedBolusString,
                    iobValue: viewModel.iobString,
                    onCalculations: {
                        // TODO: Show calculations breakdown
                    },
                    onDeliver: {
                        viewModel.deliverBolus { success in
                            if success {
                                onDismiss()
                            }
                        }
                    },
                    onCancel: {
                        onDismiss()
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing),
                    removal: .move(edge: .trailing)
                ))
            }
        }
        .navigationBarHidden(true)
    }

    private func formatCarbsForSummary() -> String {
        if viewModel.carbsString.isEmpty || viewModel.carbsString == "0" {
            return "0 g"
        }
        return "\(viewModel.carbsString) g"
    }
}

// MARK: - Bolus Flow Step

enum BolusFlowStep {
    case input
    case confirm
}

// MARK: - View Model Protocol

/// Protocol defining the interface for bolus view model
/// Allows wrapping existing SimpleBolusViewModel without modification
public protocol InsuBolusViewModelProtocol: ObservableObject {
    var carbsString: String { get set }
    var glucoseString: String { get set }
    var recommendedBolusString: String { get }
    var iobString: String { get }
    var mealBolusString: String { get }
    var correctionBolusString: String { get }

    func useSensorGlucose()
    func deliverBolus(completion: @escaping (Bool) -> Void)
}

// MARK: - Preview Mock ViewModel

#if DEBUG
class MockInsuBolusViewModel: InsuBolusViewModelProtocol {
    @Published var carbsString: String = "0"
    @Published var glucoseString: String = ""

    var recommendedBolusString: String { "0" }
    var iobString: String { "0.75 U" }
    var mealBolusString: String { "0 U" }
    var correctionBolusString: String { "0 U" }

    func useSensorGlucose() {
        glucoseString = "7.2"
    }

    func deliverBolus(completion: @escaping (Bool) -> Void) {
        completion(true)
    }
}

struct InsuBolusFlowView_Previews: PreviewProvider {
    static var previews: some View {
        InsuBolusFlowView(
            viewModel: MockInsuBolusViewModel(),
            userName: "Arian",
            glucoseUnit: "mmol/L",
            onDismiss: {}
        )
        .previewDisplayName("Bolus Flow")
    }
}
#endif
