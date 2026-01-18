//
//  ChatMessageView.swift
//  Loop
//
//  Created for INSU Nutrition Assistant
//

import SwiftUI
import LoopUI

/// View for displaying a single chat message
struct ChatMessageView: View {
    let message: ChatMessage
    let onSuggestionTapped: (CarbSuggestionData) -> Void
    let onReceiptTapped: (Double) -> Void

    var body: some View {
        HStack {
            if message.sender == .user {
                Spacer(minLength: 40)
            }

            messageContent

            if message.sender == .assistant {
                Spacer(minLength: 40)
            }
        }
    }

    @ViewBuilder
    private var messageContent: some View {
        switch message.content {
        case .text(let text):
            TextBubble(text: text, isUser: message.sender == .user)

        case .image(let image):
            ImageBubble(image: image)

        case .carbSuggestion(let suggestion):
            CarbSuggestionCard(suggestion: suggestion, onTap: {
                onSuggestionTapped(suggestion)
            })

        case .carbReceipt(let receipt):
            CarbReceiptCard(receipt: receipt, onTap: {
                onReceiptTapped(receipt.totalCarbs)
            })

        case .loading:
            TypingIndicator()
        }
    }
}

/// Text message bubble with markdown support
struct TextBubble: View {
    let text: String
    let isUser: Bool

    var body: some View {
        Group {
            if let attributedString = try? AttributedString(markdown: text, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
                Text(attributedString)
            } else {
                Text(text)
            }
        }
        .font(.system(size: 16))
        .padding(12)
        .background(isUser ? Color.insuDarkBlue : Color.insuBlue)
        .foregroundColor(isUser ? .white : .black)
        .cornerRadius(16)
    }
}

/// Image message bubble
struct ImageBubble: View {
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 200)
            .cornerRadius(16)
            .clipped()
    }
}

/// Tappable card for carbohydrate suggestions
struct CarbSuggestionCard: View {
    let suggestion: CarbSuggestionData
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // Food name header
                HStack {
                    Image(systemName: "fork.knife")
                        .foregroundColor(.insuDarkBlue)
                    Text(suggestion.foodName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.black)
                    Spacer()
                }

                // Portion description
                Text(suggestion.portionDescription)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)

                // Carbs and action
                HStack {
                    Text("\(Int(suggestion.estimatedCarbs))g carbs")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.insuDarkBlue)

                    Spacer()

                    Text("Tap to use")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)

                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.insuDarkBlue)
                }

                // Confidence indicator
                HStack(spacing: 4) {
                    Circle()
                        .fill(suggestion.confidence.color)
                        .frame(width: 8, height: 8)
                    Text(suggestion.confidence.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Animated typing indicator for loading state
struct TypingIndicator: View {
    @State private var animating = false

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Color.insuDarkBlue)
                    .frame(width: 8, height: 8)
                    .scaleEffect(animating ? 1.0 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: animating
                    )
            }
        }
        .padding(12)
        .background(Color.insuBlue)
        .cornerRadius(16)
        .onAppear { animating = true }
    }
}

/// Receipt-style card showing multiple food items with totals
struct CarbReceiptCard: View {
    let receipt: CarbReceiptData
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.insuDarkBlue)
                Text("Meal Summary")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Dashed divider
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.gray.opacity(0.5))
                .frame(height: 1)
                .padding(.horizontal, 12)

            // Item list
            VStack(spacing: 8) {
                ForEach(receipt.items) { item in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(item.foodName)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.black)
                            Text(item.portionDescription)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .lineLimit(1)
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Circle()
                                .fill(item.confidence.color)
                                .frame(width: 6, height: 6)
                            Text("\(Int(item.estimatedCarbs))g")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.black)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Dashed divider
            DashedLine()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.gray.opacity(0.5))
                .frame(height: 1)
                .padding(.horizontal, 12)

            // Total
            HStack {
                Text("TOTAL")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.gray)
                Spacer()
                Text("\(Int(receipt.totalCarbs))g carbs")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.insuDarkBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            // Confidence note
            HStack(spacing: 4) {
                Circle()
                    .fill(receipt.overallConfidence.color)
                    .frame(width: 8, height: 8)
                Text(receipt.overallConfidence.description)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)

            // Notes if available
            if let notes = receipt.notes, !notes.isEmpty {
                Text(notes)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
            }

            // Action button
            Button(action: onTap) {
                HStack {
                    Spacer()
                    Text("Use \(Int(receipt.totalCarbs))g carbs")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 14)
                .background(Color.insuDarkBlue)
                .cornerRadius(12)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
}

/// Dashed line shape for receipt dividers
struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}
