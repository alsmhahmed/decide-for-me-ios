//
//  PrioritiesService.swift
//  DecideForMe
//
//  Reads/writes the `priorities` string at `users/{uid}`.
//

import Foundation
import FirebaseFirestore

final class PrioritiesService {
    private let db = Firestore.firestore()

    private func document(for uid: String) -> DocumentReference {
        db.collection("users").document(uid)
    }

    /// Live snapshot listener. `onChange` receives the saved priorities
    /// string ("" when the document or field doesn't exist yet).
    func listen(uid: String,
                onChange: @escaping (String) -> Void,
                onError: @escaping (Error) -> Void) -> ListenerRegistration {
        document(for: uid).addSnapshotListener { snapshot, error in
            if let error {
                onError(error)
                return
            }
            let value = snapshot?.data()?["priorities"] as? String ?? ""
            onChange(value)
        }
    }

    func save(uid: String, priorities: String) async throws {
        try await document(for: uid).setData(["priorities": priorities], merge: true)
    }
}
