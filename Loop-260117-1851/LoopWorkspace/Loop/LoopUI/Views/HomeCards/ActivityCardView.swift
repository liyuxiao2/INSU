//
//  ActivityCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct ActivityCardView: View {
    let onActivity: () -> Void

    public init(onActivity: @escaping () -> Void) {
        self.onActivity = onActivity
    }

    public var body: some View {
        Button(action: onActivity) {
            ZStack {
                // Outer blue card
                RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                    .fill(Color.insuBlue)

                // Inner white card
                VStack(spacing: 8) {
                    // Activity icon - running person
                    Image(systemName: "figure.run")
                        .font(.system(size: 50, weight: .regular))
                        .foregroundColor(Color.insuDarkBlue)

                    Text("Activity")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color.insuTextPrimary)
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
        ActivityCardView(onActivity: {})
            .frame(width: 157, height: 118)
            .padding()
            .previewDisplayName("Activity Card")
    }
}
