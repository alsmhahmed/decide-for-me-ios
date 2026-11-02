//
//  MainView.swift
//  DecideForMe
//
//  "Main Screen - Chat & Dilemma Input"
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = ChatViewModel()
    @State private var showSettings = false

    var body: some View {
        VStack(spacing: 0) {
            header
            conversation
        }
        .background(Theme.Colors.surface.ignoresSafeArea())
        .safeAreaInset(edge: .bottom, spacing: 0) {
            DilemmaInputBar(
                optionA: $viewModel.optionA,
                optionB: $viewModel.optionB,
                canSubmit: viewModel.canSubmit,
                isDisabled: viewModel.isLoading,
                onSubmit: {
                    UIApplication.shared.sendAction(
                        #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    withAnimation(.easeOut(duration: 0.25)) { viewModel.submit() }
                }
            )
        }
        .sheet(isPresented: $viewModel.showPriorities) {
            PrioritiesSheet(viewModel: viewModel.priorities) {
                viewModel.showPriorities = false
            }
            .applyAppLanguage()
        }
        .sheet(isPresented: $showSettings) {
            SettingsSheet { showSettings = false }
                .applyAppLanguage()
        }
        .task { await viewModel.bootstrap() }
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Text("app.title")
                .textStyle(Theme.Typography.headlineSm)
            Spacer()
            HStack(spacing: Theme.Spacing.sm) {
                Button {
                    viewModel.showPriorities = true
                } label: {
                    Text("button.my_priorities")
                        .textStyle(Theme.Typography.labelLg, color: Theme.Colors.primary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Theme.Colors.surfaceContainerHigh))
                        .overlay(Capsule().stroke(Theme.Colors.outlineVariant.opacity(0.4), lineWidth: 1))
                        .shadow(color: Color(hex: 0x0F172A, opacity: 0.05), radius: 1.5, y: 1)
                }
                .buttonStyle(PressableButtonStyle())

                Button {
                    showSettings = true
                } label: {
                    Image(systemName: "gearshape")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Theme.Colors.primary)
                        .frame(width: 30, height: 30)
                        .background(Circle().fill(Theme.Colors.surfaceContainerHigh))
                        .overlay(Circle().stroke(Theme.Colors.outlineVariant.opacity(0.4), lineWidth: 1))
                        .shadow(color: Color(hex: 0x0F172A, opacity: 0.05), radius: 1.5, y: 1)
                }
                .buttonStyle(PressableButtonStyle())
                .accessibilityLabel("button.settings")
            }
        }
        .padding(.horizontal, Theme.Spacing.margin)
        .padding(.vertical, Theme.Spacing.sm)
        .background(
            ZStack {
                Rectangle().fill(.ultraThinMaterial)
                Theme.Colors.surface.opacity(0.9)
            }
            .ignoresSafeArea(edges: .top)
        )
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Theme.Colors.outlineVariant.opacity(0.3))
                .frame(height: 1)
        }
    }

    // MARK: Conversation

    private var conversation: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: Theme.Spacing.md) {
                    ForEach(viewModel.messages) { message in
                        row(for: message)
                            .id(message.id)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .padding(.horizontal, Theme.Spacing.margin)
                .padding(.top, Theme.Spacing.lg)
                .padding(.bottom, Theme.Spacing.md)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages) { _, messages in
                guard let last = messages.last else { return }
                withAnimation(.easeOut(duration: 0.3)) {
                    proxy.scrollTo(last.id, anchor: .bottom)
                }
            }
        }
    }

    @ViewBuilder
    private func row(for message: ChatMessage) -> some View {
        switch message.kind {
        case .assistant(let text):
            AssistantMessageRow(text: LocalizedStringKey(text))
        case .userDilemma(let a, let b):
            UserDilemmaRow(optionA: a, optionB: b)
        case .loading:
            LoadingRow()
        case .verdict(let result):
            VerdictRow(result: result)
        case .error(let text):
            ErrorRow(text: LocalizedStringKey(text))
        case .hint(let text):
            HintRow(text: LocalizedStringKey(text))
        }
    }
}

#Preview {
    MainView()
        .applyAppLanguage()
}
