//
//  ChatViewModel.swift
//  DecideForMe
//

import Foundation
import Combine

final class ChatViewModel: ObservableObject {
    @Published private(set) var messages: [ChatMessage] = [
        ChatMessage(kind: .assistant("chat.first_message"))
    ]
    @Published var optionA = ""
    @Published var optionB = ""
    @Published private(set) var isLoading = false
    @Published var showPriorities = false

    let priorities = PrioritiesViewModel()
    private let authService: AuthService
    private let deciderService: DeciderService

    init(authService: AuthService = AuthService(),
         deciderService: DeciderService = DeciderService()) {
        self.authService = authService
        self.deciderService = deciderService
    }

    var canSubmit: Bool {
        !isLoading
        && !optionA.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !optionB.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Signs in anonymously at launch, then starts the priorities listener.
    func bootstrap() async {
        do {
            let uid = try await authService.signInAnonymously()
            priorities.start(uid: uid)
        } catch {
            print("❌ Anonymous sign-in failed: \(error)")
            priorities.errorMessage = error.localizedDescription
        }
    }

    /// Posts both options as one user message, shows the loading state, calls the
    /// "decider-flow" template, then swaps the loading bubble for the result or an error.
    func submit() {
        guard canSubmit else { return }
        let a = optionA.trimmingCharacters(in: .whitespacesAndNewlines)
        let b = optionB.trimmingCharacters(in: .whitespacesAndNewlines)
        let savedPriorities = priorities.savedPriorities

        messages.append(ChatMessage(kind: .userDilemma(optionA: a, optionB: b)))
        if savedPriorities.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messages.append(ChatMessage(kind: .hint("hint.add_priorities")))
        }
        let loading = ChatMessage(kind: .loading)
        messages.append(loading)
        isLoading = true
        optionA = ""
        optionB = ""

        Task { @MainActor in
            let reply: ChatMessage
            do {
                let result = try await deciderService.decide(
                    priorities: savedPriorities, optionA: a, optionB: b)
                reply = ChatMessage(kind: .verdict(result))
            } catch {
                print("❌ decider-flow request failed: \(error)")
                reply = ChatMessage(kind: .error("error.generic"))
            }
            if let index = messages.firstIndex(where: { $0.id == loading.id }) {
                messages[index] = reply
            } else {
                messages.append(reply)
            }
            isLoading = false
        }
    }
}
