//
//  InsuBolusCardComponents.swift
//  LoopUI
//
//  Created for Loop redesign - Bolus flow card components
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

// MARK: - Input Card (for Carbs, Glucose)

/// A card component for bolus input fields
public struct InsuBolusInputCard: View {
    let label: String
    @Binding var value: String
    let unit: String
    let placeholder: String
    let actionLabel: String?
    let onAction: (() -> Void)?
    let subtitle: String?
    let subtitleLabel: String?

    public init(
        label: String,
        value: Binding<String>,
        unit: String,
        placeholder: String = "0",
        actionLabel: String? = nil,
        onAction: (() -> Void)? = nil,
        subtitle: String? = nil,
        subtitleLabel: String? = nil
    ) {
        self.label = label
        self._value = value
        self.unit = unit
        self.placeholder = placeholder
        self.actionLabel = actionLabel
        self.onAction = onAction
        self.subtitle = subtitle
        self.subtitleLabel = subtitleLabel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Header row: Label + Action button
            HStack {
                Text(label)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color.insuTextPrimary)

                Spacer()

                if let actionLabel = actionLabel, let onAction = onAction {
                    Button(action: onAction) {
                        Text(actionLabel)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.insuDarkBlue)
                    }
                }
            }

            // Value row: Large value + Unit
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                TextField(placeholder, text: $value)
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundColor(Color.insuTextPrimary)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(unit)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(Color.insuGray)
                    .padding(.bottom, 8)
            }

            // Optional subtitle
            if let subtitle = subtitle, let subtitleLabel = subtitleLabel {
                Text("\(subtitleLabel): \(subtitle)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.insuGray)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(InsuSpacing.innerCardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: InsuSpacing.innerCardCornerRadius)
                .stroke(Color.insuDarkBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Display Card (read-only, for Total Bolus)

/// A card component for displaying computed values (read-only)
public struct InsuBolusDisplayCard: View {
    let label: String
    let value: String
    let unit: String
    let actionLabel: String?
    let onAction: (() -> Void)?
    let iobValue: String?

    public init(
        label: String,
        value: String,
        unit: String,
        actionLabel: String? = nil,
        onAction: (() -> Void)? = nil,
        iobValue: String? = nil
    ) {
        self.label = label
        self.value = value
        self.unit = unit
        self.actionLabel = actionLabel
        self.onAction = onAction
        self.iobValue = iobValue
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Header row: Label + Action button
            HStack {
                Text(label)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color.insuTextPrimary)

                Spacer()

                if let actionLabel = actionLabel, let onAction = onAction {
                    Button(action: onAction) {
                        Text(actionLabel)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color.insuDarkBlue)
                    }
                }
            }

            // Value row: Large value + Unit
            HStack(alignment: .firstTextBaseline, spacing: 8) {
                Text(value)
                    .font(.system(size: 50, weight: .semibold))
                    .foregroundColor(Color.insuTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(unit)
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(Color.insuGray)
                    .padding(.bottom, 8)
            }

            // IOB subtitle
            if let iobValue = iobValue {
                Text("IOB of \(iobValue)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(Color.insuGray)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(InsuSpacing.innerCardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: InsuSpacing.innerCardCornerRadius)
                .stroke(Color.insuDarkBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Summary Card (for Confirm screen)

/// A card component for the bolus confirmation summary
public struct InsuBolusSummaryCard: View {
    let carbsValue: String
    let glucoseValue: String
    let glucoseUnit: String
    let bolusNowPercent: String
    let mealBolusValue: String

    public init(
        carbsValue: String,
        glucoseValue: String,
        glucoseUnit: String = "mmol/L",
        bolusNowPercent: String = "100%",
        mealBolusValue: String
    ) {
        self.carbsValue = carbsValue
        self.glucoseValue = glucoseValue
        self.glucoseUnit = glucoseUnit
        self.bolusNowPercent = bolusNowPercent
        self.mealBolusValue = mealBolusValue
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Summary")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color.insuTextPrimary)
                Spacer()
            }
            .padding(.bottom, 12)

            // Summary rows
            VStack(spacing: 12) {
                SummaryRow(label: "Carbs", value: carbsValue, valueColor: .insuTextPrimary)

                SummaryRow(label: "Glucose", value: glucoseValue.isEmpty ? "--" : glucoseValue, valueColor: .insuTextPrimary)

                VStack(alignment: .leading, spacing: 2) {
                    SummaryRow(label: "Bolus Now", value: bolusNowPercent, valueColor: .insuTextPrimary)
                    Text("Meal: \(mealBolusValue)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(Color.insuGray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 0)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(InsuSpacing.innerCardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: InsuSpacing.innerCardCornerRadius)
                .stroke(Color.insuDarkBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Summary Row

private struct SummaryRow: View {
    let label: String
    let value: String
    let valueColor: Color

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Color.insuTextPrimary)
            Spacer()
            Text(value)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(valueColor)
        }
    }
}

// MARK: - Total Bolus Card (for Confirm screen bottom)

/// Large total bolus display for confirmation screen
public struct InsuBolusTotalCard: View {
    let value: String
    let iobValue: String
    let onCalculations: (() -> Void)?

    public init(
        value: String,
        iobValue: String,
        onCalculations: (() -> Void)? = nil
    ) {
        self.value = value
        self.iobValue = iobValue
        self.onCalculations = onCalculations
    }

    public var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Bolus")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.insuTextPrimary)

                    if let onCalculations = onCalculations {
                        Button(action: onCalculations) {
                            Text("Calculations")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color.insuDarkBlue)
                        }
                    }
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text(value)
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(Color.insuDarkBlue)
                        Text("U")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(Color.insuDarkBlue)
                    }

                    Text("IOB of \(iobValue)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(Color.insuGray)
                }
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(InsuSpacing.innerCardCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: InsuSpacing.innerCardCornerRadius)
                .stroke(Color.insuDarkBlue.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Previews

struct InsuBolusCardComponents_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 20) {
                InsuBolusInputCard(
                    label: "Carbs",
                    value: .constant("0"),
                    unit: "g",
                    actionLabel: "Custom Foods",
                    onAction: {}
                )

                InsuBolusInputCard(
                    label: "Glucose",
                    value: .constant(""),
                    unit: "mmol/L",
                    placeholder: "--",
                    actionLabel: "Use Sensor",
                    onAction: {}
                )

                InsuBolusDisplayCard(
                    label: "Total Bolus",
                    value: "0",
                    unit: "U",
                    actionLabel: "Calculations",
                    onAction: {},
                    iobValue: "0.75 U"
                )

                InsuBolusSummaryCard(
                    carbsValue: "0 g",
                    glucoseValue: "",
                    bolusNowPercent: "100%",
                    mealBolusValue: "0.35 U"
                )

                InsuBolusTotalCard(
                    value: "1",
                    iobValue: "1.65 U",
                    onCalculations: {}
                )
            }
            .padding()
        }
        .background(Color.insuBlue)
        .previewDisplayName("Bolus Card Components")
    }
}
