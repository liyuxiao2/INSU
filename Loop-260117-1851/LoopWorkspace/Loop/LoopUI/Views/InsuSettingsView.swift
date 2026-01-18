//
//  InsuSettingsView.swift
//  LoopUI
//
//  Created for Loop redesign - Settings page matching Figma design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct InsuSettingsView: View {

    public init() {}

    public var body: some View {
        NavigationView {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Settings")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.black)

                        HStack(spacing: 0) {
                            Text("Configure your ")
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            Text("Settings")
                                .font(.system(size: 16, weight: .bold))
                                .italic()
                                .foregroundColor(.black)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                    .padding(.top, 16)

                    // Settings Sections
                    VStack(spacing: 12) {
                        NavigationLink(destination: RemindersSettingsView()) {
                            SettingsRowContent(title: "Reminders")
                        }

                        NavigationLink(destination: GlucoseGoalRangeSettingsView()) {
                            SettingsRowContent(title: "Glucose Goal Range")
                        }

                        NavigationLink(destination: BolusAndTempBasalSettingsView()) {
                            SettingsRowContent(title: "Bolus & Temp Basal")
                        }

                        NavigationLink(destination: BolusSettingsView()) {
                            SettingsRowContent(title: "Bolus")
                        }
                    }
                    .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                    .padding(.top, 24)

                    Spacer()

                    // Log Out Button
                    Button(action: {
                        // Log out action
                    }) {
                        Text("Log Out")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.insuDarkBlue)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                    .padding(.bottom, InsuSpacing.tabBarHeight + 40)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Settings Row Content

struct SettingsRowContent: View {
    let title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            Image(systemName: "chevron.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.insuDarkBlue)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.insuBlue)
        .cornerRadius(10)
    }
}

// MARK: - Reminders Settings View

struct RemindersSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var bloodGlucoseReminder = true
    @State private var bolusReminder = true
    @State private var podChangeReminder = true
    @State private var reminderFrequency = "Every 4 hours"

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsDetailHeader(title: "Reminders", onBack: { presentationMode.wrappedValue.dismiss() })

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsSectionCard(title: "Glucose Reminders") {
                            SettingsToggleRow(label: "Blood Glucose Check", isOn: $bloodGlucoseReminder)
                            SettingsPickerRow(label: "Frequency", value: reminderFrequency)
                        }

                        SettingsSectionCard(title: "Insulin Reminders") {
                            SettingsToggleRow(label: "Bolus Reminder", isOn: $bolusReminder)
                            SettingsToggleRow(label: "Pod Change Reminder", isOn: $podChangeReminder)
                        }

                        SettingsSectionCard(title: "Notification Settings") {
                            SettingsInfoRow(label: "Sound", value: "Default")
                            SettingsInfoRow(label: "Badge", value: "Enabled")
                        }
                    }
                    .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// MARK: - Glucose Goal Range Settings View

struct GlucoseGoalRangeSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var lowThreshold = "3.9"
    @State private var highThreshold = "10.0"
    @State private var targetGlucose = "6.0"
    @State private var unit = "mmol/L"

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsDetailHeader(title: "Glucose Goal Range", onBack: { presentationMode.wrappedValue.dismiss() })

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsSectionCard(title: "Target Range") {
                            SettingsTextField(label: "Low Threshold", text: $lowThreshold, suffix: unit)
                            SettingsTextField(label: "High Threshold", text: $highThreshold, suffix: unit)
                        }

                        SettingsSectionCard(title: "Target Glucose") {
                            SettingsTextField(label: "Target", text: $targetGlucose, suffix: unit)
                        }

                        SettingsSectionCard(title: "Display") {
                            SettingsPickerRow(label: "Unit", value: unit)
                        }

                        // Info card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Recommended Ranges")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)
                            Text("The American Diabetes Association recommends a target range of 3.9-10.0 mmol/L (70-180 mg/dL) for most adults with diabetes.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.insuBlue.opacity(0.5))
                        .cornerRadius(12)
                    }
                    .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// MARK: - Bolus and Temp Basal Settings View

struct BolusAndTempBasalSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var maxBasalRate = "2.0"
    @State private var maxBolus = "10.0"
    @State private var tempBasalType = "Percentage"

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsDetailHeader(title: "Bolus & Temp Basal", onBack: { presentationMode.wrappedValue.dismiss() })

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsSectionCard(title: "Maximum Rates") {
                            SettingsTextField(label: "Max Basal Rate", text: $maxBasalRate, suffix: "U/hr")
                            SettingsTextField(label: "Max Bolus", text: $maxBolus, suffix: "U")
                        }

                        SettingsSectionCard(title: "Temp Basal") {
                            SettingsPickerRow(label: "Type", value: tempBasalType)
                            SettingsInfoRow(label: "Duration", value: "30 min - 24 hrs")
                        }

                        SettingsSectionCard(title: "Basal Schedule") {
                            SettingsInfoRow(label: "12:00 AM - 6:00 AM", value: "0.8 U/hr")
                            SettingsInfoRow(label: "6:00 AM - 12:00 PM", value: "1.0 U/hr")
                            SettingsInfoRow(label: "12:00 PM - 6:00 PM", value: "0.9 U/hr")
                            SettingsInfoRow(label: "6:00 PM - 12:00 AM", value: "0.85 U/hr")
                        }
                    }
                    .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// MARK: - Bolus Settings View

struct BolusSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var insulinSensitivity = "2.5"
    @State private var carbRatio = "10"
    @State private var insulinDuration = "4.0"

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsDetailHeader(title: "Bolus", onBack: { presentationMode.wrappedValue.dismiss() })

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsSectionCard(title: "Insulin Sensitivity Factor") {
                            SettingsTextField(label: "ISF", text: $insulinSensitivity, suffix: "mmol/L per U")
                            Text("How much 1 unit of insulin lowers your blood glucose")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        SettingsSectionCard(title: "Carb Ratio") {
                            SettingsTextField(label: "ICR", text: $carbRatio, suffix: "g per U")
                            Text("Grams of carbs covered by 1 unit of insulin")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        SettingsSectionCard(title: "Insulin Activity") {
                            SettingsTextField(label: "Duration", text: $insulinDuration, suffix: "hours")
                            Text("How long insulin remains active in your body")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        SettingsSectionCard(title: "Bolus Calculator") {
                            SettingsInfoRow(label: "Active Insulin", value: "Enabled")
                            SettingsInfoRow(label: "Glucose Trend", value: "Enabled")
                        }
                    }
                    .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

// MARK: - Reusable Components

struct SettingsDetailHeader: View {
    let title: String
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color.insuDarkBlue)
            }

            Spacer()

            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            // Spacer for balance
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
        .padding(.vertical, 16)
        .background(Color.white)
    }
}

struct SettingsSectionCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.insuDarkBlue)

            VStack(spacing: 12) {
                content
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct SettingsTextField: View {
    let label: String
    @Binding var text: String
    var suffix: String? = nil

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.black)

            Spacer()

            HStack(spacing: 4) {
                TextField("", text: $text)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.insuDarkBlue)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 80)

                if let suffix = suffix {
                    Text(suffix)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct SettingsToggleRow: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.black)

            Spacer()

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: Color.insuDarkBlue))
        }
        .padding(.vertical, 4)
    }
}

struct SettingsPickerRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.black)

            Spacer()

            HStack(spacing: 4) {
                Text(value)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color.insuDarkBlue)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 4)
    }
}

struct SettingsInfoRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.black)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Color.insuDarkBlue)
        }
        .padding(.vertical, 4)
    }
}
