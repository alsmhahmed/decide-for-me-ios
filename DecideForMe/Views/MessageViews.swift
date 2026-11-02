//
//  MessageViews.swift
//  DecideForMe
//

import SwiftUI

/// Round indigo avatar with the "psychology" glyph from the design.
struct AssistantAvatar: View {
    var body: some View {
        Image(systemName: "brain.head.profile")
            .font(.system(size: 16, weight: .medium))
            .foregroundStyle(Theme.Colors.onPrimary)
            .frame(width: Theme.Metrics.avatarSize, height: Theme.Metrics.avatarSize)
            .background(Circle().fill(Theme.Colors.primaryContainer))
            .shadow(color: Color(hex: 0x0F172A, opacity: 0.08), radius: 2, y: 1)
            .padding(.top, 2)
    }
}

/// Bubble with a squared "tail" corner (top-left for assistant, bottom-right for user).
private struct BubbleShape: Shape {
    let tailOnLeading: Bool

    /// Flip the tail corner in right-to-left layouts.
    var layoutDirectionBehavior: LayoutDirectionBehavior { .mirrors }

    func path(in rect: CGRect) -> Path {
        let big = Theme.Radius.xxl
        let small = Theme.Radius.small
        return UnevenRoundedRectangle(
            topLeadingRadius: tailOnLeading ? small : big,
            bottomLeadingRadius: big,
            bottomTrailingRadius: tailOnLeading ? big : small,
            topTrailingRadius: big,
            style: .continuous
        ).path(in: rect)
    }
}

struct AssistantMessageRow: View {
    let text: LocalizedStringKey
    var timestamp: LocalizedStringKey? = LocalizedStringKey("chat.just_now")

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AssistantAvatar()
            VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
                Text(text)
                    .textStyle(Theme.Typography.bodyMd)
                    .padding(.horizontal, Theme.Spacing.md)
                    .padding(.vertical, 12)
                    .background(BubbleShape(tailOnLeading: true).fill(Theme.Colors.surfaceContainerLow))
                    .overlay(
                        BubbleShape(tailOnLeading: true)
                            .stroke(Theme.Colors.outlineVariant.opacity(0.4), lineWidth: 1)
                    )
                    .shadow(color: Color(hex: 0x0F172A, opacity: 0.04), radius: 1.5, y: 1)
                if let timestamp {
                    Text(timestamp)
                        .textStyle(Theme.Typography.caption, color: Theme.Colors.outline)
                        .padding(.leading, Theme.Spacing.xs)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 40)
    }
}

/// Right-aligned user message containing both options.
struct UserDilemmaRow: View {
    let optionA: String
    let optionB: String

    var body: some View {
        HStack {
            Spacer(minLength: 56)
            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                optionLine(label: "option.a.label", text: optionA)
                optionLine(label: "option.b.label", text: optionB)
            }
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, 12)
            .background(BubbleShape(tailOnLeading: false).fill(Theme.Colors.primaryContainer))
            .shadow(color: Color(hex: 0x4F46E5, opacity: 0.18), radius: 6, y: 2)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }

    private func optionLine(label: LocalizedStringKey, text: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .textStyle(Theme.Typography.labelMd, color: Theme.Colors.onPrimary.opacity(0.75))
            Text(text)
                .textStyle(Theme.Typography.bodyMd, color: Theme.Colors.onPrimary)
                .multilineTextAlignment(.leading)
        }
    }
}

/// Left-aligned system bubble with the three labeled verdict fields.
struct VerdictRow: View {
    let result: DeciderVerdict

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AssistantAvatar()
            VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                field(title: "result.verdict", text: result.verdict, emphasized: true)
                divider
                field(title: "result.justification", text: result.justification)
                divider
                field(title: "result.first_step", text: result.firstStep)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Theme.Spacing.md)
            .padding(.vertical, 12)
            .background(BubbleShape(tailOnLeading: true).fill(Theme.Colors.surfaceContainerLow))
            .overlay(
                BubbleShape(tailOnLeading: true)
                    .stroke(Theme.Colors.outlineVariant.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: Color(hex: 0x0F172A, opacity: 0.04), radius: 1.5, y: 1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 12)
    }

    private var divider: some View {
        Rectangle()
            .fill(Theme.Colors.outlineVariant.opacity(0.4))
            .frame(height: 1)
    }

    private func field(title: LocalizedStringKey, text: String, emphasized: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            Text(title)
                .textCase(.uppercase)
                .textStyle(Theme.Typography.caption, color: Theme.Colors.primary)
            Text(text)
                .textStyle(emphasized ? Theme.Typography.bodyBold : Theme.Typography.bodyMd)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

/// Short, friendly error bubble from the assistant.
struct ErrorRow: View {
    let text: LocalizedStringKey

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AssistantAvatar()
            Text(text)
                .textStyle(Theme.Typography.bodyMd, color: Theme.Colors.error)
                .padding(.horizontal, Theme.Spacing.md)
                .padding(.vertical, 12)
                .background(BubbleShape(tailOnLeading: true).fill(Theme.Colors.surfaceContainerLow))
                .overlay(
                    BubbleShape(tailOnLeading: true)
                        .stroke(Theme.Colors.error.opacity(0.3), lineWidth: 1)
                )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.trailing, 40)
    }
}

/// Small unobtrusive hint line.
struct HintRow: View {
    let text: LocalizedStringKey

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "lightbulb")
                .font(.system(size: 11, weight: .medium))
            Text(text)
        }
        .textStyle(Theme.Typography.caption, color: Theme.Colors.outline)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .multilineTextAlignment(.trailing)
    }
}

/// Sleek assistant "thinking" state: avatar + pulsing dots in a bubble.
struct LoadingRow: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AssistantAvatar()
            TypingDots()
                .padding(.horizontal, Theme.Spacing.md)
                .frame(height: 46)
                .background(BubbleShape(tailOnLeading: true).fill(Theme.Colors.surfaceContainerLow))
                .overlay(
                    BubbleShape(tailOnLeading: true)
                        .stroke(Theme.Colors.outlineVariant.opacity(0.4), lineWidth: 1)
                )
                .shadow(color: Color(hex: 0x0F172A, opacity: 0.04), radius: 1.5, y: 1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityLabel("chat.loading")
    }
}

private struct TypingDots: View {
    @State private var phase = false

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(Theme.Colors.primaryContainer)
                    .frame(width: 8, height: 8)
                    .scaleEffect(phase ? 1 : 0.55)
                    .opacity(phase ? 1 : 0.35)
                    .animation(
                        .easeInOut(duration: 0.6)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.18),
                        value: phase
                    )
            }
        }
        .onAppear { phase = true }
    }
}
