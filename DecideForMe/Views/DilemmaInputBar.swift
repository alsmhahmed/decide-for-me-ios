//
//  DilemmaInputBar.swift
//  DecideForMe
//
//  Bottom-docked console with Option A / Option B inputs and the "Go" button.
//

import SwiftUI

struct DilemmaInputBar: View {
    @Binding var optionA: String
    @Binding var optionB: String
    let canSubmit: Bool
    let isDisabled: Bool
    let onSubmit: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.sm) {
            OptionField(
                label: "option.a.label",
                dotColor: Theme.Colors.primary,
                placeholder: "option.a.placeholder",
                text: $optionA,
                isDisabled: isDisabled
            )
            OptionField(
                label: "option.b.label",
                dotColor: Theme.Colors.secondary,
                placeholder: "option.b.placeholder",
                text: $optionB,
                isDisabled: isDisabled
            )

            Button(action: onSubmit) {
                HStack(spacing: Theme.Spacing.sm) {
                    Text("button.go")
                    Image(systemName: "arrow.right")
                        .font(.system(size: 18, weight: .semibold))
                        .flipsForRightToLeftLayoutDirection(true)
                }
                .textStyle(Theme.Typography.headlineSm, color: Theme.Colors.onPrimary)
                .frame(maxWidth: .infinity)
                .frame(height: Theme.Metrics.primaryButtonHeight)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .fill(Theme.Colors.primaryContainer)
                )
                .shadow(color: Color(hex: 0x0F172A, opacity: 0.12), radius: 4, y: 2)
                .opacity(canSubmit ? 1 : 0.5)
            }
            .buttonStyle(PressableButtonStyle())
            .disabled(!canSubmit)
            .padding(.top, Theme.Spacing.xs)
        }
        .padding(.horizontal, Theme.Spacing.margin)
        .padding(.top, Theme.Spacing.md)
        .padding(.bottom, Theme.Spacing.sm)
        .background(
            ZStack {
                Rectangle().fill(.ultraThinMaterial)
                Theme.Colors.surfaceContainerLowest.opacity(0.9)
            }
            .clipShape(UnevenRoundedRectangle(
                topLeadingRadius: Theme.Radius.xxxl,
                topTrailingRadius: Theme.Radius.xxxl,
                style: .continuous
            ))
            .overlay(
                UnevenRoundedRectangle(
                    topLeadingRadius: Theme.Radius.xxxl,
                    topTrailingRadius: Theme.Radius.xxxl,
                    style: .continuous
                )
                .stroke(Theme.Colors.outlineVariant.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: Color(hex: 0x0F172A, opacity: 0.05), radius: 10, y: -4)
            .ignoresSafeArea(edges: .bottom)
        )
    }
}

private struct OptionField: View {
    let label: LocalizedStringKey
    let dotColor: Color
    let placeholder: LocalizedStringKey
    @Binding var text: String
    let isDisabled: Bool

    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xs) {
            HStack(spacing: 6) {
                Circle().fill(dotColor).frame(width: 8, height: 8)
                Text(label)
                    .textStyle(Theme.Typography.labelMd, color: Theme.Colors.onSurfaceVariant)
            }
            .padding(.horizontal, Theme.Spacing.xs)

            TextField(
                "",
                text: $text,
                prompt: Text(placeholder).foregroundColor(Theme.Colors.outline)
            )
            .focused($focused)
            .textStyle(Theme.Typography.bodyMd)
            .submitLabel(.done)
            .disabled(isDisabled)
            .padding(.horizontal, 14)
            .frame(height: Theme.Metrics.inputHeight)
            .background(
                RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                    .fill(focused ? Theme.Colors.surfaceContainerLowest : Theme.Colors.surfaceContainerLow)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                    .strokeBorder(
                        focused ? Theme.Colors.primary : Theme.Colors.outlineVariant.opacity(0.5),
                        lineWidth: 1
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.Radius.xl + 2, style: .continuous)
                    .stroke(Theme.Colors.primary.opacity(focused ? 0.2 : 0), lineWidth: 2)
                    .padding(-2)
            )
            .animation(.easeOut(duration: 0.15), value: focused)
            .opacity(isDisabled ? 0.6 : 1)
        }
    }
}
