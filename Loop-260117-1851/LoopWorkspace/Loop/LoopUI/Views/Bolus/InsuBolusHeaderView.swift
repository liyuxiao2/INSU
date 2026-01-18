//
//  InsuBolusHeaderView.swift
//  LoopUI
//
//  Created for Loop redesign - Bolus flow header
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

/// Reusable header component for bolus flow screens
/// Matches the home page header styling exactly
public struct InsuBolusHeaderView: View {
    let userName: String
    let action: String  // "Input", "Confirm"

    public init(userName: String, action: String) {
        self.userName = userName
        self.action = action
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Hello, \(userName)")
                    .font(InsuTypography.greeting)
                    .foregroundColor(Color.insuTextPrimary)

                HStack(spacing: 0) {
                    Text("\(action) your ")
                        .font(InsuTypography.subtitle)
                        .foregroundColor(Color.insuTextPrimary)
                    Text("Bolus")
                        .font(InsuTypography.subtitleBold)
                        .foregroundColor(Color.insuTextPrimary)
                    Text(" Below")
                        .font(InsuTypography.subtitle)
                        .foregroundColor(Color.insuTextPrimary)
                }
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 26))
                    .foregroundColor(Color.insuTextPrimary)
            }
        }
        .padding(.horizontal, InsuSpacing.screenHorizontalPadding)
        .padding(.top, 16)
    }
}

// MARK: - Preview

struct InsuBolusHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InsuBolusHeaderView(userName: "Arian", action: "Input")
            Spacer()
            InsuBolusHeaderView(userName: "Arian", action: "Confirm")
            Spacer()
        }
        .previewDisplayName("Bolus Headers")
    }
}
