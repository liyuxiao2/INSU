//
//  ChatMessage.swift
//  Loop
//
//  Created for INSU Nutrition Assistant
//

import Foundation
import SwiftUI

/// Represents who sent a chat message
enum MessageSender {
    case user
    case assistant
}

/// The content type of a chat message
enum MessageContent {
    case text(String)
    case image(UIImage)
    case carbSuggestion(CarbSuggestionData)
    case carbReceipt(CarbReceiptData)
    case loading
}

/// Data for a receipt-style card showing multiple food items
struct CarbReceiptData: Identifiable {
    let id = UUID()
    let items: [CarbSuggestionData]
    let notes: String?

    var totalCarbs: Double {
        items.reduce(0) { $0 + $1.estimatedCarbs }
    }

    var overallConfidence: CarbSuggestionData.CarbConfidence {
        // Use the lowest confidence from all items
        if items.contains(where: { $0.confidence == .low }) {
            return .low
        } else if items.contains(where: { $0.confidence == .medium }) {
            return .medium
        }
        return .high
    }
}

/// Data for a carbohydrate suggestion card
struct CarbSuggestionData: Identifiable {
    let id = UUID()
    let foodName: String
    let estimatedCarbs: Double
    let confidence: CarbConfidence
    let portionDescription: String

    enum CarbConfidence: String {
        case high
        case medium
        case low

        var description: String {
            switch self {
            case .high: return "High confidence"
            case .medium: return "Medium confidence"
            case .low: return "Low confidence - verify portions"
            }
        }

        var color: Color {
            switch self {
            case .high: return .green
            case .medium: return .orange
            case .low: return .red
            }
        }
    }

    init(foodName: String, estimatedCarbs: Double, confidence: CarbConfidence, portionDescription: String) {
        self.foodName = foodName
        self.estimatedCarbs = estimatedCarbs
        self.confidence = confidence
        self.portionDescription = portionDescription
    }
}

/// A single chat message in the conversation
struct ChatMessage: Identifiable {
    let id = UUID()
    let sender: MessageSender
    let content: MessageContent
    let timestamp: Date

    init(sender: MessageSender, content: MessageContent) {
        self.sender = sender
        self.content = content
        self.timestamp = Date()
    }
}
