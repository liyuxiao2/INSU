//
//  NutritionAssistantHeader.swift
//  Loop
//
//  Created for INSU Nutrition Assistant
//

import SwiftUI
import LoopUI

/// Header view for the Nutrition Assistant modal
struct NutritionAssistantHeader: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.black)
                        .frame(width: 32, height: 32)
                        .background(Color.insuBlue)
                        .cornerRadius(16)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("Nutrition Assistant")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.black)

                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 8, height: 8)
                        Text("Powered by AI")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }

                Spacer()

                // Placeholder for balance
                Color.clear.frame(width: 32, height: 32)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Divider()
        }
        .background(Color.white)
    }
}
