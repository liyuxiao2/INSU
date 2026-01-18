//
//  InsuBolusConfirmView.swift
//  LoopUI
//
//  Created for Loop redesign - Bolus flow Step 2: Confirm
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

/// Step 2 of bolus flow: Review summary and deliver bolus
public struct InsuBolusConfirmView: View {
    let userName: String
    let carbsValue: String
    let glucoseValue: String
    let glucoseUnit: String
    let bolusNowPercent: String
    let mealBolusValue: String
    let totalBolus: String
    let iobValue: String

    let onCalculations: () -> Void
    let onDeliver: () -> Void
    let onCancel: () -> Void

    public init(
        userName: String,
        carbsValue: String,
        glucoseValue: String,
        glucoseUnit: String,
        bolusNowPercent: String = "100%",
        mealBolusValue: String,
        totalBolus: String,
        iobValue: String,
        onCalculations: @escaping () -> Void,
        onDeliver: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.userName = userName
        self.carbsValue = carbsValue
        self.glucoseValue = glucoseValue
        self.glucoseUnit = glucoseUnit
        self.bolusNowPercent = bolusNowPercent
        self.mealBolusValue = mealBolusValue
        self.totalBolus = totalBolus
        self.iobValue = iobValue
        self.onCalculations = onCalculations
        self.onDeliver = onDeliver
        self.onCancel = onCancel
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            InsuBolusHeaderView(userName: userName, action: "Confirm")

            // Content
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Card
                    InsuBolusSummaryCard(
                        carbsValue: carbsValue,
                        glucoseValue: glucoseValue,
                        glucoseUnit: glucoseUnit,
                        bolusNowPercent: bolusNowPercent,
                        mealBolusValue: mealBolusValue
                    )

                    // Total Bolus Card
                    InsuBolusTotalCard(
                        value: totalBolus,
                        iobValue: iobValue,
                        onCalculations: onCalculations
                    )
                }
                .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                .padding(.top, 20)
            }

            Spacer()

            // Bottom buttons
            VStack(spacing: 12) {
                // Deliver Bolus button with arrow
                Button(action: onDeliver) {
                    HStack {
                        Spacer()
                        Text("Deliver Bolus")
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

struct InsuBolusConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        InsuBolusConfirmView(
            userName: "Arian",
            carbsValue: "0 g",
            glucoseValue: "",
            glucoseUnit: "mmol/L",
            bolusNowPercent: "100%",
            mealBolusValue: "0.35 U",
            totalBolus: "1",
            iobValue: "1.65 U",
            onCalculations: {},
            onDeliver: {},
            onCancel: {}
        )
        .previewDisplayName("Confirm Bolus Screen")
    }
}
