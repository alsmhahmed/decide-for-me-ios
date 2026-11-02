//
//  PrioritiesViewModel.swift
//  DecideForMe
//

import Foundation
import Combine
import FirebaseFirestore

final class PrioritiesViewModel: ObservableObject {
    @Published private(set) var savedPriorities: String = ""
    @Published var draft: String = ""
    @Published var isEditing = false
    @Published private(set) var isSaving = false
    @Published var errorMessage: String?

    private let service: PrioritiesService
    private var uid: String?
    private var listener: ListenerRegistration?

    init(service: PrioritiesService = PrioritiesService()) {
        self.service = service
    }

    deinit { listener?.remove() }

    /// Starts the live Firestore listener for `users/{uid}`.
    func start(uid: String) {
        guard self.uid != uid else { return }
        self.uid = uid
        listener?.remove()
        listener = service.listen(
            uid: uid,
            onChange: { [weak self] value in
                Task { @MainActor in self?.savedPriorities = value }
            },
            onError: { [weak self] error in
                Task { @MainActor in self?.errorMessage = error.localizedDescription }
            }
        )
    }

    func beginEditing() {
        draft = savedPriorities
        isEditing = true
    }

    func cancelEditing() {
        isEditing = false
        draft = ""
    }

    func save() {
        guard let uid, !isSaving else { return }
        isSaving = true
        let text = draft
        Task { @MainActor in
            defer { isSaving = false }
            do {
                try await service.save(uid: uid, priorities: text)
                isEditing = false
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}
