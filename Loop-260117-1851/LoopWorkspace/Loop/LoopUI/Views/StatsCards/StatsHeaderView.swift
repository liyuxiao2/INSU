//
//  StatsHeaderView.swift
//  LoopUI
//
//  Created for Loop redesign - Stats page header
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct StatsHeaderView: View {
    let userName: String

    public init(userName: String) {
        self.userName = userName
    }

    public var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Hello, \(userName)")
                    .font(InsuTypography.greeting)
                    .foregroundColor(Color.insuTextPrimary)

                HStack(spacing: 4) {
                    Text("View your ")
                        .font(InsuTypography.subtitle)
                        .foregroundColor(Color.insuTextPrimary)
                    + Text("Sensor Info")
                        .font(InsuTypography.subtitleBold)
                        .foregroundColor(Color.insuTextPrimary)
                }
            }

            Spacer()

            // Notification bell
            Button(action: {
                // Notification action - decorative for now
            }) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 24))
                    .foregroundColor(Color.insuTextPrimary)
            }
            .padding(.top, 8)
        }
        .padding(.top, 16)
    }
}

// MARK: - Preview

struct StatsHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        StatsHeaderView(userName: "Arian")
            .padding(.horizontal, 20)
            .previewLayout(.sizeThatFits)
    }
}
