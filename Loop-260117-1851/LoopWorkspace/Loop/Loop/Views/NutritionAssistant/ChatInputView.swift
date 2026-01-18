//
//  ChatInputView.swift
//  Loop
//
//  Created for INSU Nutrition Assistant
//

import SwiftUI
import LoopUI

/// Input view for the chat interface with text field and camera button
struct ChatInputView: View {
    @Binding var text: String
    let isLoading: Bool
    let onSend: () -> Void
    let onCamera: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 12) {
                // Camera button
                Button(action: onCamera) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.insuDarkBlue)
                        .frame(width: 44, height: 44)
                        .background(Color.insuBlue)
                        .cornerRadius(22)
                }
                .disabled(isLoading)
                .opacity(isLoading ? 0.5 : 1)

                // Text field
                TextField("Ask about food or carbs...", text: $text)
                    .font(.system(size: 16))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.insuBlue.opacity(0.5))
                    .cornerRadius(20)
                    .disabled(isLoading)

                // Send button
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(canSend ? .insuDarkBlue : .gray)
                }
                .disabled(!canSend)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
        }
    }

    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }
}
