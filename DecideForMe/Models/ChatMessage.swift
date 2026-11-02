//
//  ChatMessage.swift
//  DecideForMe
//

import Foundation

struct ChatMessage: Identifiable, Equatable {
    enum Kind: Equatable {
        /// String payloads of `.assistant`, `.error` and `.hint` are String Catalog keys.
        case assistant(String)
        /// A single user message carrying both options.
        case userDilemma(optionA: String, optionB: String)
        case loading
        case verdict(DeciderVerdict)
        case error(String)
        /// Small, subtle note (e.g. "add priorities for better results").
        case hint(String)
    }

    let id = UUID()
    let kind: Kind
}
