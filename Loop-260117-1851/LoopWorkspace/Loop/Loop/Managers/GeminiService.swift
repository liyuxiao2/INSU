//
//  GeminiService.swift
//  Loop
//
//  Created for INSU Nutrition Assistant
//

import Foundation
import UIKit

/// Service for interacting with Google's Gemini API for food/nutrition analysis
class GeminiService {
    static let shared = GeminiService()

    private var apiKey: String? {
        Bundle.main.object(forInfoDictionaryKey: "GeminiAPIKey") as? String
    }

    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"

    private init() {}

    // MARK: - Response Types

    struct GeminiResponse: Codable {
        let candidates: [Candidate]?
        let error: GeminiAPIError?

        struct Candidate: Codable {
            let content: Content
        }

        struct Content: Codable {
            let parts: [Part]
        }

        struct Part: Codable {
            let text: String?
        }

        struct GeminiAPIError: Codable {
            let message: String
            let status: String?
        }
    }

    struct FoodAnalysisResponse: Codable {
        let foods: [FoodItem]?
        let total_carbs: Double?
        let notes: String?

        struct FoodItem: Codable {
            let name: String
            let portion: String
            let carbs: Double
            let confidence: String
        }
    }

    // MARK: - Public Types

    struct CarbSuggestion: Identifiable {
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

            init(from string: String) {
                switch string.lowercased() {
                case "high": self = .high
                case "medium": self = .medium
                default: self = .low
                }
            }
        }
    }

    struct FoodAnalysisResult {
        let suggestions: [CarbSuggestion]
        let totalCarbs: Double
        let notes: String?
    }

    enum GeminiError: Error, LocalizedError {
        case missingAPIKey
        case imageConversionFailed
        case apiError(String)
        case invalidResponse
        case networkError(Error)

        var errorDescription: String? {
            switch self {
            case .missingAPIKey:
                return "Gemini API key not configured. Please add your API key to GeminiAPIKey.xcconfig"
            case .imageConversionFailed:
                return "Failed to process image"
            case .apiError(let message):
                return "API error: \(message)"
            case .invalidResponse:
                return "Invalid response from API"
            case .networkError(let error):
                return "Network error: \(error.localizedDescription)"
            }
        }
    }

    // MARK: - API Methods

    /// Analyze a food image and return carbohydrate estimates
    func analyzeFood(image: UIImage) async throws -> FoodAnalysisResult {
        guard let apiKey = apiKey, !apiKey.isEmpty, apiKey != "YOUR_API_KEY_HERE" else {
            throw GeminiError.missingAPIKey
        }

        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            throw GeminiError.imageConversionFailed
        }

        let base64Image = imageData.base64EncodedString()

        let prompt = """
        Analyze this food image and estimate the carbohydrate content for diabetes management.

        Return your response in this exact JSON format only, with no other text:
        {
            "foods": [
                {
                    "name": "Food name",
                    "portion": "Description of portion size you see",
                    "carbs": estimated_carbs_in_grams_as_number,
                    "confidence": "high" or "medium" or "low"
                }
            ],
            "total_carbs": total_estimated_carbs_as_number,
            "notes": "Any relevant notes about the estimation"
        }

        Guidelines:
        - Be conservative with estimates
        - If portion size is unclear, use medium or low confidence
        - Round carbs to nearest whole number
        - Include all visible food items separately
        - If you cannot identify the food, still provide a reasonable estimate with low confidence
        """

        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.1,
                "maxOutputTokens": 1024
            ]
        ]

        return try await makeRequest(requestBody: requestBody, parseAsFood: true)
    }

    /// Send a text message to the nutrition assistant
    func sendMessage(_ message: String) async throws -> String {
        guard let apiKey = apiKey, !apiKey.isEmpty, apiKey != "YOUR_API_KEY_HERE" else {
            throw GeminiError.missingAPIKey
        }

        let prompt = """
        You are a helpful nutrition assistant for people with diabetes managing their carbohydrate intake.

        Guidelines:
        - Help estimate carbohydrates in foods
        - Provide nutrition guidance relevant to diabetes management
        - Be concise and helpful
        - If asked about specific foods, provide carb estimates per typical serving
        - Always mention that estimates should be verified with food labels when available
        - Do not provide medical advice about insulin dosing

        User message: \(message)
        """

        let requestBody: [String: Any] = [
            "contents": [
                ["parts": [["text": prompt]]]
            ],
            "generationConfig": [
                "temperature": 0.7,
                "maxOutputTokens": 512
            ]
        ]

        return try await makeTextRequest(requestBody: requestBody)
    }

    // MARK: - Private Methods

    private func makeRequest(requestBody: [String: Any], parseAsFood: Bool) async throws -> FoodAnalysisResult {
        guard let apiKey = apiKey else {
            throw GeminiError.missingAPIKey
        }

        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw GeminiError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw GeminiError.invalidResponse
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw GeminiError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let errorResponse = try? JSONDecoder().decode(GeminiResponse.self, from: data),
               let error = errorResponse.error {
                throw GeminiError.apiError(error.message)
            }
            throw GeminiError.apiError("HTTP \(httpResponse.statusCode)")
        }

        let geminiResponse: GeminiResponse
        do {
            geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        } catch {
            throw GeminiError.invalidResponse
        }

        guard let text = geminiResponse.candidates?.first?.content.parts.first?.text else {
            throw GeminiError.invalidResponse
        }

        return parseGeminiResponse(text)
    }

    private func makeTextRequest(requestBody: [String: Any]) async throws -> String {
        guard let apiKey = apiKey else {
            throw GeminiError.missingAPIKey
        }

        guard let url = URL(string: "\(baseURL)?key=\(apiKey)") else {
            throw GeminiError.invalidResponse
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 30

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            throw GeminiError.invalidResponse
        }

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw GeminiError.networkError(error)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }

        if httpResponse.statusCode != 200 {
            if let errorResponse = try? JSONDecoder().decode(GeminiResponse.self, from: data),
               let error = errorResponse.error {
                throw GeminiError.apiError(error.message)
            }
            throw GeminiError.apiError("HTTP \(httpResponse.statusCode)")
        }

        let geminiResponse: GeminiResponse
        do {
            geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)
        } catch {
            throw GeminiError.invalidResponse
        }

        guard let text = geminiResponse.candidates?.first?.content.parts.first?.text else {
            throw GeminiError.invalidResponse
        }

        return text
    }

    private func parseGeminiResponse(_ text: String) -> FoodAnalysisResult {
        // Try to extract JSON from the response
        var jsonString = text

        // Handle markdown code blocks
        if let jsonStart = text.range(of: "```json"),
           let jsonEnd = text.range(of: "```", range: jsonStart.upperBound..<text.endIndex) {
            jsonString = String(text[jsonStart.upperBound..<jsonEnd.lowerBound])
        } else if let jsonStart = text.range(of: "```"),
                  let jsonEnd = text.range(of: "```", range: jsonStart.upperBound..<text.endIndex) {
            jsonString = String(text[jsonStart.upperBound..<jsonEnd.lowerBound])
        }

        // Try to find JSON object in the text
        if let start = jsonString.firstIndex(of: "{"),
           let end = jsonString.lastIndex(of: "}") {
            jsonString = String(jsonString[start...end])
        }

        guard let jsonData = jsonString.data(using: .utf8),
              let foodResponse = try? JSONDecoder().decode(FoodAnalysisResponse.self, from: jsonData) else {
            // Return a fallback if parsing fails
            return FoodAnalysisResult(
                suggestions: [
                    CarbSuggestion(
                        foodName: "Unable to analyze",
                        estimatedCarbs: 0,
                        confidence: .low,
                        portionDescription: "Could not parse food details"
                    )
                ],
                totalCarbs: 0,
                notes: "Failed to parse response. Raw: \(text.prefix(200))"
            )
        }

        let suggestions = (foodResponse.foods ?? []).map { food in
            CarbSuggestion(
                foodName: food.name,
                estimatedCarbs: food.carbs,
                confidence: CarbSuggestion.CarbConfidence(from: food.confidence),
                portionDescription: food.portion
            )
        }

        return FoodAnalysisResult(
            suggestions: suggestions,
            totalCarbs: foodResponse.total_carbs ?? suggestions.reduce(0) { $0 + $1.estimatedCarbs },
            notes: foodResponse.notes
        )
    }
}
