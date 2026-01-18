//
//  PauseGlucoseCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct PauseGlucoseCardView: View {
    let isSuspended: Bool
    let onToggle: () -> Void

    public init(isSuspended: Bool = false, onToggle: @escaping () -> Void) {
        self.isSuspended = isSuspended
        self.onToggle = onToggle
    }

    public var body: some View {
        Button(action: onToggle) {
            ZStack {
                // Outer blue card
                RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                    .fill(Color.insuBlue)

                // Inner white card
                VStack(spacing: 8) {
                    // Icon changes based on state
                    Image(systemName: isSuspended ? "play.fill" : "pause.fill")
                        .font(.system(size: 44, weight: .regular))
                        .foregroundColor(isSuspended ? .green : Color.insuDarkBlue)

                    Text(isSuspended ? "Resume Insulin" : "Pause Insulin")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.insuTextPrimary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
                .cornerRadius(InsuSpacing.innerCardCornerRadius)
                .padding(6)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview

struct PauseGlucoseCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PauseGlucoseCardView(isSuspended: false, onToggle: {})
                .frame(width: 157, height: 118)
                .padding()
                .previewDisplayName("Pause Insulin")

            PauseGlucoseCardView(isSuspended: true, onToggle: {})
                .frame(width: 157, height: 118)
                .padding()
                .previewDisplayName("Resume Insulin")
        }
    }
}
