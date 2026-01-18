//
//  InsuBolusInputView.swift
//  LoopUI
//
//  Created for Loop redesign - Bolus flow Step 1: Input
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

/// Step 1 of bolus flow: Input carbs, glucose, view recommended bolus
public struct InsuBolusInputView: View {
    let userName: String
    @Binding var carbsValue: String
    @Binding var glucoseValue: String
    let glucoseUnit: String
    let totalBolus: String
    let iobValue: String
    let mealBolus: String
    let correctionBolus: String

    let onCustomFoods: () -> Void
    let onUseSensor: () -> Void
    let onCalculations: () -> Void
    let onConfirm: () -> Void
    let onCancel: () -> Void

    public init(
        userName: String,
        carbsValue: Binding<String>,
        glucoseValue: Binding<String>,
        glucoseUnit: String,
        totalBolus: String,
        iobValue: String,
        mealBolus: String,
        correctionBolus: String,
        onCustomFoods: @escaping () -> Void,
        onUseSensor: @escaping () -> Void,
        onCalculations: @escaping () -> Void,
        onConfirm: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.userName = userName
        self._carbsValue = carbsValue
        self._glucoseValue = glucoseValue
        self.glucoseUnit = glucoseUnit
        self.totalBolus = totalBolus
        self.iobValue = iobValue
        self.mealBolus = mealBolus
        self.correctionBolus = correctionBolus
        self.onCustomFoods = onCustomFoods
        self.onUseSensor = onUseSensor
        self.onCalculations = onCalculations
        self.onConfirm = onConfirm
        self.onCancel = onCancel
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            InsuBolusHeaderView(userName: userName, action: "Input")

            // Scrollable content
            ScrollView {
                VStack(spacing: 16) {
                    // Carbs Card
                    InsuBolusInputCard(
                        label: "Carbs",
                        value: $carbsValue,
                        unit: "g",
                        placeholder: "0",
                        actionLabel: "Custom Foods",
                        onAction: onCustomFoods,
                        subtitle: mealBolus,
                        subtitleLabel: "Meal Bolus"
                    )

                    // Glucose Card
                    InsuBolusInputCard(
                        label: "Glucose",
                        value: $glucoseValue,
                        unit: glucoseUnit,
                        placeholder: "--",
                        actionLabel: "Use Sensor",
                        onAction: onUseSensor,
                        subtitle: correctionBolus,
                        subtitleLabel: "Correction Bolus"
                    )

                    // Total Bolus Card
                    InsuBolusDisplayCard(
                        label: "Total Bolus",
                        value: totalBolus,
                        unit: "U",
                        actionLabel: "Calculations",
                        onAction: onCalculations,
                        iobValue: iobValue
                    )
                }
                .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                .padding(.top, 20)
            }

            Spacer()

            // Bottom buttons
            VStack(spacing: 12) {
                // Confirm Bolus button with arrow
                Button(action: onConfirm) {
                    HStack {
                        Spacer()
                        Text("Confirm Bolus")
                        Image(systemName: "arrow.right")
                        Spacer()
                    }
                }
                .buttonStyle(InsuPrimaryButtonStyle())

                // Cancel button
                Button(action: onCancel) {
                    Text("Cancel")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color.insuTextPrimary)
                }
            }
            .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
            .padding(.bottom, 20)
        }
        .background(Color.insuBlue)
    }
}

// MARK: - Preview

struct InsuBolusInputView_Previews: PreviewProvider {
    static var previews: some View {
        InsuBolusInputView(
            userName: "Arian",
            carbsValue: .constant("0"),
            glucoseValue: .constant(""),
            glucoseUnit: "mmol/L",
            totalBolus: "0",
            iobValue: "0.75 U",
            mealBolus: "0 U",
            correctionBolus: "0 U",
            onCustomFoods: {},
            onUseSensor: {},
            onCalculations: {},
            onConfirm: {},
            onCancel: {}
        )
        .previewDisplayName("Input Bolus Screen")
    }
}
