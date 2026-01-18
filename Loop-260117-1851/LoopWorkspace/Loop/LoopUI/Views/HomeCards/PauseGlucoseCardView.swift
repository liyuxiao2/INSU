//
//  PauseGlucoseCardView.swift
//  LoopUI
//
//  Created for Loop redesign - matches Figma "home page" design
//  Copyright © 2026. All rights reserved.
//

import SwiftUI

public struct PauseGlucoseCardView: View {
    let onPause: () -> Void

    public init(onPause: @escaping () -> Void) {
        self.onPause = onPause
    }

    public var body: some View {
        Button(action: onPause) {
            ZStack {
                // Outer blue card
                RoundedRectangle(cornerRadius: InsuSpacing.cardCornerRadius)
                    .fill(Color.insuBlue)

                // Inner white card
                VStack(spacing: 8) {
                    // Pause icon
                    Image(systemName: "pause.fill")
                        .font(.system(size: 44, weight: .regular))
                        .foregroundColor(Color.insuDarkBlue)

                    Text("Pause Glucose")
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
        PauseGlucoseCardView(onPause: {})
            .frame(width: 157, height: 118)
            .padding()
            .previewDisplayName("Pause Glucose Card")
    }
}
