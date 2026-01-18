//
//  InsuSettingsView.swift
//  Loop
//
//  Created for Loop redesign - Settings page matching Figma design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI
import LoopUI

struct InsuSettingsView: View {
    @ObservedObject var alertPermissionsChecker: AlertPermissionsChecker
    @ObservedObject var alertMuter: AlertMuter

    init(alertPermissionsChecker: AlertPermissionsChecker, alertMuter: AlertMuter) {
        self.alertPermissionsChecker = alertPermissionsChecker
        self.alertMuter = alertMuter
    }

    var body: some View {
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
                        NavigationLink(destination: AlertManagementSettingsView(
                            alertPermissionsChecker: alertPermissionsChecker,
                            alertMuter: alertMuter
                        )) {
                            SettingsRowContentWithWarning(
                                title: "Alert Management",
                                showWarning: alertPermissionsChecker.showWarning || alertMuter.configuration.shouldMute
                            )
                        }

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

                        NavigationLink(destination: WorkoutSettingsView()) {
                            SettingsRowContent(title: "Workout / Activity")
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

// MARK: - Settings Row Content With Warning

private struct SettingsRowContentWithWarning: View {
    let title: String
    let showWarning: Bool

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.black)

            Spacer()

            if showWarning {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)
                    .padding(.trailing, 8)
            }

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

// MARK: - Settings Row Content

private struct SettingsRowContent: View {
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

// MARK: - Alert Management Settings View

struct AlertManagementSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var alertPermissionsChecker: AlertPermissionsChecker
    @ObservedObject var alertMuter: AlertMuter

    @State private var showMuteAlertOptions = false
    @State private var missedMealNotificationsEnabled = UserDefaults.standard.bool(forKey: "com.loopkit.Loop.MissedMealNotificationsEnabled")

    private var formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()

    init(alertPermissionsChecker: AlertPermissionsChecker, alertMuter: AlertMuter) {
        self.alertPermissionsChecker = alertPermissionsChecker
        self.alertMuter = alertMuter
    }

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsDetailHeader(title: "Alert Management", onBack: { presentationMode.wrappedValue.dismiss() })

                ScrollView {
                    VStack(spacing: 16) {
                        // Alert Permissions Section
                        SettingsSectionCard(title: "Permissions") {
                            HStack {
                                Text("Alert Permissions")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)

                                Spacer()

                                if alertPermissionsChecker.showWarning {
                                    Image(systemName: "exclamationmark.triangle.fill")
                                        .font(.system(size: 14))
                                        .foregroundColor(.orange)
                                        .padding(.trailing, 4)
                                }

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 4)

                            HStack {
                                Text("Notifications")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)

                                Spacer()

                                Text(!alertPermissionsChecker.notificationCenterSettings.notificationsDisabled ? "Enabled" : "Disabled")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(!alertPermissionsChecker.notificationCenterSettings.notificationsDisabled ? Color.insuDarkBlue : .orange)
                            }
                            .padding(.vertical, 4)

                            HStack {
                                Text("Critical Alerts")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)

                                Spacer()

                                Text(!alertPermissionsChecker.notificationCenterSettings.criticalAlertsDisabled ? "Enabled" : "Disabled")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(!alertPermissionsChecker.notificationCenterSettings.criticalAlertsDisabled ? Color.insuDarkBlue : .orange)
                            }
                            .padding(.vertical, 4)
                        }

                        // Mute Alerts Section
                        SettingsSectionCard(title: "Mute Alerts") {
                            if !alertMuter.configuration.shouldMute {
                                Button(action: { showMuteAlertOptions = true }) {
                                    HStack {
                                        Image(systemName: "speaker.slash.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .frame(width: 28, height: 28)
                                            .background(Color.orange)
                                            .cornerRadius(6)

                                        Text("Mute All Alerts")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color.insuDarkBlue)

                                        Spacer()
                                    }
                                }
                                .actionSheet(isPresented: $showMuteAlertOptions) {
                                    ActionSheet(
                                        title: Text("Mute All Alerts"),
                                        message: Text("Select how long you would like to mute alerts."),
                                        buttons: muteAlertDurationButtons()
                                    )
                                }
                            } else {
                                Button(action: { alertMuter.unmuteAlerts() }) {
                                    HStack {
                                        Image(systemName: "speaker.wave.2.fill")
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .frame(width: 28, height: 28)
                                            .background(Color.green)
                                            .cornerRadius(6)

                                        Text("Tap to Unmute")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(Color.insuDarkBlue)

                                        Spacer()
                                    }
                                }

                                HStack {
                                    Text("Muted Until")
                                        .font(.system(size: 14))
                                        .foregroundColor(.black)

                                    Spacer()

                                    Text(alertMuter.formattedEndTime)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.orange)
                                }
                                .padding(.vertical, 4)
                            }
                        }

                        // Missed Meal Notifications
                        SettingsSectionCard(title: "Meal Detection") {
                            HStack {
                                Text("Missed Meal Notifications")
                                    .font(.system(size: 14))
                                    .foregroundColor(.black)

                                Spacer()

                                Toggle("", isOn: $missedMealNotificationsEnabled)
                                    .labelsHidden()
                                    .toggleStyle(SwitchToggleStyle(tint: Color.insuDarkBlue))
                                    .onChange(of: missedMealNotificationsEnabled) { newValue in
                                        UserDefaults.standard.set(newValue, forKey: "com.loopkit.Loop.MissedMealNotificationsEnabled")
                                    }
                            }
                            .padding(.vertical, 4)

                            Text("When enabled, Loop can notify you when it detects a meal that wasn't logged.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        // Info Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "iphone")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.insuDarkBlue)
                                    .frame(width: 40)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("App Sounds")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("While mute alerts is on, all alerts will temporarily display without sounds and will vibrate only.")
                                        .font(.system(size: 11))
                                        .foregroundColor(.gray)
                                }
                            }

                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "moon.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.insuDarkBlue)
                                    .frame(width: 40)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("iOS Focus Modes")
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.black)
                                    Text("Critical Alerts will still be delivered during Focus modes. Add Loop to allowed apps for other notifications.")
                                        .font(.system(size: 11))
                                        .foregroundColor(.gray)
                                }
                            }
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

    private func muteAlertDurationButtons() -> [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = AlertMuter.allowedDurations.compactMap { duration in
            guard let formattedDuration = formatter.string(from: duration) else { return nil }
            return .default(Text(formattedDuration)) {
                alertMuter.configuration.startTime = Date()
                alertMuter.configuration.duration = duration
            }
        }
        buttons.append(.cancel())
        return buttons
    }
}

// MARK: - Reminders Settings View

private struct RemindersSettingsView: View {
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

private struct GlucoseGoalRangeSettingsView: View {
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

private struct BolusAndTempBasalSettingsView: View {
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

private struct BolusSettingsView: View {
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

// MARK: - Workout Settings View

private struct WorkoutSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var workoutLowTarget = "8.0"
    @State private var workoutHighTarget = "10.0"
    @State private var isWorkoutEnabled = true
    @State private var unit = "mmol/L"

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {
                SettingsDetailHeader(title: "Workout / Activity", onBack: { presentationMode.wrappedValue.dismiss() })

                ScrollView {
                    VStack(spacing: 16) {
                        SettingsSectionCard(title: "Workout Correction Range") {
                            SettingsToggleRow(label: "Enable Workout Target", isOn: $isWorkoutEnabled)

                            if isWorkoutEnabled {
                                SettingsTextField(label: "Low Target", text: $workoutLowTarget, suffix: unit)
                                SettingsTextField(label: "High Target", text: $workoutHighTarget, suffix: unit)
                            }
                        }

                        // Info card
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 8) {
                                Image(systemName: "figure.run")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.insuDarkBlue)
                                Text("About Workout Mode")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.black)
                            }

                            Text("When you activate Workout mode from the home screen, Loop will target a higher glucose range to help prevent lows during physical activity.")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)

                            Text("Recommended workout range: 8.0-10.0 mmol/L (140-180 mg/dL)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(Color.insuDarkBlue)
                                .padding(.top, 4)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.insuBlue.opacity(0.5))
                        .cornerRadius(12)

                        // How to use card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("How to Use")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.black)

                            HStack(alignment: .top, spacing: 12) {
                                Text("1.")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.insuDarkBlue)
                                Text("Configure your workout target range above")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }

                            HStack(alignment: .top, spacing: 12) {
                                Text("2.")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.insuDarkBlue)
                                Text("Tap the Activity button on the home screen before exercising")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }

                            HStack(alignment: .top, spacing: 12) {
                                Text("3.")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.insuDarkBlue)
                                Text("Select how long you'll be active")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }

                            HStack(alignment: .top, spacing: 12) {
                                Text("4.")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.insuDarkBlue)
                                Text("Tap the Activity button again when done to end workout mode")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
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

private struct SettingsDetailHeader: View {
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

private struct SettingsSectionCard<Content: View>: View {
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

private struct SettingsTextField: View {
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

private struct SettingsToggleRow: View {
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

private struct SettingsPickerRow: View {
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

private struct SettingsInfoRow: View {
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
