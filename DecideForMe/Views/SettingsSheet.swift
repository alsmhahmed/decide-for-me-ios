//
//  SettingsSheet.swift
//  DecideForMe
//
//  Small bottom sheet with the in-app language picker (English / العربية).
//

import SwiftUI

struct SettingsSheet: View {
    @AppStorage(AppLanguage.storageKey) private var appLanguage = AppLanguage.english.rawValue
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Capsule()
                .fill(Theme.Colors.outlineVariant.opacity(0.8))
                .frame(width: 40, height: 6)
                .padding(.top, 12)
                .padding(.bottom, 6)

            HStack {
                Text("settings.title")
                    .textStyle(Theme.Typography.headlineMd)
                Spacer()
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Theme.Colors.onSurfaceVariant)
                        .frame(width: 36, height: 36)
                        .contentShape(Rectangle())
                }
                .buttonStyle(PressableButtonStyle())
                .accessibilityLabel("button.close")
            }
            .padding(.horizontal, Theme.Spacing.margin)
            .padding(.top, Theme.Spacing.sm)

            VStack(alignment: .leading, spacing: Theme.Spacing.sm) {
                Text("settings.language")
                    .textStyle(Theme.Typography.labelMd, color: Theme.Colors.onSurfaceVariant)
                    .padding(.horizontal, Theme.Spacing.xs)

                // Segmented control styled per the design system.
                HStack(spacing: 0) {
                    ForEach(AppLanguage.allCases) { language in
                        segment(language)
                    }
                }
                .padding(4)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .fill(Theme.Colors.surfaceContainer)
                )
            }
            .padding(.horizontal, Theme.Spacing.margin)
            .padding(.top, Theme.Spacing.md)

            Spacer(minLength: 0)
        }
        .background(Theme.Colors.surfaceContainerLowest.ignoresSafeArea())
        .presentationDetents([.height(250)])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(Theme.Radius.sheet)
        .presentationBackground(Theme.Colors.surfaceContainerLowest)
    }

    private func segment(_ language: AppLanguage) -> some View {
        let selected = appLanguage == language.rawValue
        return Button {
            withAnimation(.easeInOut(duration: 0.2)) { appLanguage = language.rawValue }
        } label: {
            // Native names are shown as-is (never translated).
            Text(verbatim: language.nativeName)
                .environment(\.locale, Locale(identifier: language.rawValue))
                .textStyle(
                    Theme.Typography.bodyBold,
                    color: selected ? Theme.Colors.primary : Theme.Colors.onSurfaceVariant
                )
                .frame(maxWidth: .infinity)
                .frame(height: 40)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.lg, style: .continuous)
                        .fill(selected ? Theme.Colors.surfaceContainerLowest : .clear)
                        .shadow(color: Color(hex: 0x0F172A, opacity: selected ? 0.06 : 0), radius: 2, y: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}
