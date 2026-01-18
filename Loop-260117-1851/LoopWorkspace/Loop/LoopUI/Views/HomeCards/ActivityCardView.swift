//
//  ActivityCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct ActivityCardView: View {
    let isWorkoutActive: Bool
    let onActivity: () -> Void

    public init(isWorkoutActive: Bool = false, onActivity: @escaping () -> Void) {
        self.isWorkoutActive = isWorkoutActive
        self.onActivity = onActivity
    }

    public var body: some View {
        Button(action: onActivity) {
            ZStack {
                // Outer blue card - green when workout active
                RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                    .fill(isWorkoutActive ? Color.green.opacity(0.3) : Color.insuBlue)

                // Inner white card
                VStack(spacing: 8) {
                    // Activity icon - running person
                    Image(systemName: isWorkoutActive ? "figure.run.circle.fill" : "figure.run")
                        .font(.system(size: 50, weight: .regular))
                        .foregroundColor(isWorkoutActive ? .green : Color.insuDarkBlue)

                    Text(isWorkoutActive ? "Workout Active" : "Activity")
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

struct ActivityCardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityCardView(isWorkoutActive: false, onActivity: {})
                .frame(width: 157, height: 118)
                .padding()
                .previewDisplayName("Activity - Inactive")

            ActivityCardView(isWorkoutActive: true, onActivity: {})
                .frame(width: 157, height: 118)
                .padding()
                .previewDisplayName("Activity - Workout Active")
        }
    }
}
