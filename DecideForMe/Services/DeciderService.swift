//
//  DeciderService.swift
//  DecideForMe
//
//  Calls the "decider-flow" Firebase AI Logic server prompt template.
//

import Foundation
import FirebaseAI

enum DeciderError: LocalizedError {
    case emptyResponse
    case invalidJSON(raw: String, underlying: Error)

    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "The model returned an empty response."
        case .invalidJSON(let raw, let underlying):
            return "Could not decode model JSON (\(underlying)). Raw response: \(raw)"
        }
    }
}

final class DeciderService {
    static let templateID = "decider-flow"

    private let model = FirebaseAI.firebaseAI(backend: .googleAI()).templateGenerativeModel()

    func decide(priorities: String, optionA: String, optionB: String) async throws -> DeciderVerdict {
        let response = try await model.generateContent(
            templateID: Self.templateID,
            inputs: [
                "priorities": priorities,
                "optionA": optionA,
                "optionB": optionB
            ]
        )

        guard let text = response.text, !text.isEmpty else {
            throw DeciderError.emptyResponse
        }

        let cleaned = Self.stripCodeFences(text)
        do {
            return try JSONDecoder().decode(DeciderVerdict.self, from: Data(cleaned.utf8))
        } catch {
            throw DeciderError.invalidJSON(raw: text, underlying: error)
        }
    }

    /// Removes ```json ... ``` (or plain ```) fences if present.
    static func stripCodeFences(_ text: String) -> String {
        var result = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if result.hasPrefix("```") {
            if let newline = result.firstIndex(of: "\n") {
                result = String(result[result.index(after: newline)...])
            } else {
                result = String(result.dropFirst(3))
            }
            if result.hasSuffix("```") {
                result = String(result.dropLast(3))
            }
            result = result.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return result
    }
}
