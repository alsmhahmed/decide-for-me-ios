//
//  AuthService.swift
//  DecideForMe
//

import Foundation
import FirebaseAuth

final class AuthService {
    /// Returns the current user's uid, signing in anonymously if needed.
    func signInAnonymously() async throws -> String {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        let result = try await Auth.auth().signInAnonymously()
        return result.user.uid
    }
}
