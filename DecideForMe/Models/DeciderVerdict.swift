//
//  DeciderVerdict.swift
//  DecideForMe
//

import Foundation

/// JSON returned by the "decider-flow" server prompt template.
struct DeciderVerdict: Decodable, Equatable {
    let verdict: String
    let justification: String
    let firstStep: String
}
