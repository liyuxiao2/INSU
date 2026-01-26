//
//  NutritionAssistantViewModel.swift
//  Loop
//
//  Created for INSU Nutrition Assistant
//

import Foundation
import SwiftUI
import Combine

/// View model for the Nutrition Assistant chat interface
class NutritionAssistantViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let geminiService = GeminiService.shared

    /// Callback for when user selects a carb suggestion
    var onCarbSuggestionSelected: ((Double) -> Void)?

    init() {
        // Add welcome message
        let welcomeMessage = ChatMessage(
            sender: .assistant,
            content: .text("Hi! I'm your nutrition assistant. Take a photo of your food or describe it, and I'll help estimate the carbs for your meal.")
        )
        messages.append(welcomeMessage)
    }

    // MARK: - Methods

    /// Send a text message to the assistant
    func sendMessage() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }

        // Add user message
        let userMessage = ChatMessage(sender: .user, content: .text(trimmedText))
        messages.append(userMessage)

        // Clear input
        let messageToSend = trimmedText
        inputText = ""
        isLoading = true

        Task { @MainActor in
            do {
                let response = try await geminiService.sendMessage(messageToSend)
                let assistantMessage = ChatMessage(sender: .assistant, content: .text(response))
                messages.append(assistantMessage)
            } catch {
                let errorMsg = ChatMessage(
                    sender: .assistant,
                    content: .text("Sorry, I encountered an error: \(error.localizedDescription)")
                )
                messages.append(errorMsg)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    /// Analyze a food image
    func analyzeImage(_ image: UIImage) {
        // Add user message with image
        let userMessage = ChatMessage(sender: .user, content: .image(image))
        messages.append(userMessage)

        isLoading = true

        Task { @MainActor in
            do {
                let result = try await geminiService.analyzeFood(image: image)

                // Add explanation text
                if result.suggestions.isEmpty {
                    let textMessage = ChatMessage(
                        sender: .assistant,
                        content: .text("I couldn't identify any food in that image. Please try again with a clearer photo.")
                    )
                    messages.append(textMessage)
                } else {
                    // Convert suggestions to CarbSuggestionData
                    let items = result.suggestions.map { suggestion in
                        CarbSuggestionData(
                            foodName: suggestion.foodName,
                            estimatedCarbs: suggestion.estimatedCarbs,
                            confidence: convertConfidence(suggestion.confidence),
                            portionDescription: suggestion.portionDescription
                        )
                    }

                    // Create receipt with all items
                    let receipt = CarbReceiptData(
                        items: items,
                        notes: result.notes
                    )

                    // Add receipt card
                    let receiptMessage = ChatMessage(
                        sender: .assistant,
                        content: .carbReceipt(receipt)
                    )
                    messages.append(receiptMessage)
                }
            } catch {
                let errorMsg = ChatMessage(
                    sender: .assistant,
                    content: .text("Sorry, I couldn't analyze that image. \(error.localizedDescription)")
                )
                messages.append(errorMsg)
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    /// Handle selection of a carb suggestion
    func selectCarbSuggestion(_ suggestion: CarbSuggestionData) {
        onCarbSuggestionSelected?(suggestion.estimatedCarbs)
    }

    // MARK: - Private Methods

    private func convertConfidence(_ geminiConfidence: GeminiService.CarbSuggestion.CarbConfidence) -> CarbSuggestionData.CarbConfidence {
        switch geminiConfidence {
        case .high: return .high
        case .medium: return .medium
        case .low: return .low
        }
    }
}
