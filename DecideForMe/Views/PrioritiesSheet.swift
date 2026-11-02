//
//  PrioritiesSheet.swift
//  DecideForMe
//
//  "My Priorities - Bottom Sheet Modal"
//

import SwiftUI

struct PrioritiesSheet: View {
    @ObservedObject var viewModel: PrioritiesViewModel
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Grab handle
            Capsule()
                .fill(Theme.Colors.outlineVariant.opacity(0.8))
                .frame(width: 40, height: 6)
                .padding(.top, 12)
                .padding(.bottom, 6)

            // Header
            HStack {
                Text("priorities.title")
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
            .padding(.bottom, Theme.Spacing.sm)

            // Body
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.Spacing.md) {
                    Text("priorities.subtitle")
                        .textStyle(Theme.Typography.bodyMd, color: Theme.Colors.onSurfaceVariant)

                    if viewModel.isEditing {
                        editCard
                    } else {
                        displayCard
                    }

                    if let error = viewModel.errorMessage {
                        Text(error)
                            .textStyle(Theme.Typography.caption, color: Theme.Colors.error)
                    }
                }
                .padding(.horizontal, Theme.Spacing.margin)
                .padding(.vertical, Theme.Spacing.sm)
            }
            .scrollDismissesKeyboard(.interactively)

            actionDock
        }
        .background(Theme.Colors.surfaceContainerLowest.ignoresSafeArea())
        .presentationDetents([.fraction(0.88), .large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(Theme.Radius.sheet)
        .presentationBackground(Theme.Colors.surfaceContainerLowest)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isEditing)
    }

    // MARK: Cards

    private var displayCard: some View {
        Group {
            if viewModel.savedPriorities.isEmpty {
                Text("priorities.empty")
                    .textStyle(Theme.Typography.bodyMd, color: Theme.Colors.outline)
            } else {
                Text(viewModel.savedPriorities)
                    .textStyle(Theme.Typography.bodyMd)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xxl, style: .continuous)
                .fill(Theme.Colors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.xxl, style: .continuous)
                .stroke(Theme.Colors.outlineVariant.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: Color(hex: 0x0F172A, opacity: 0.04), radius: 1.5, y: 1)
    }

    private var editCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("priorities.edit_label")
                .textStyle(Theme.Typography.labelMd, color: Theme.Colors.onSurfaceVariant)
                .fontWeight(.semibold)

            TextEditor(text: $viewModel.draft)
                .scrollContentBackground(.hidden)
                .textStyle(Theme.Typography.bodyMd)
                .frame(minHeight: 150)
                .overlay(alignment: .topLeading) {
                    if viewModel.draft.isEmpty {
                        Text("priorities.placeholder")
                            .textStyle(Theme.Typography.bodyMd, color: Theme.Colors.outline)
                            .padding(.horizontal, 13)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .fill(Theme.Colors.surfaceContainerLowest)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                        .stroke(Theme.Colors.outlineVariant.opacity(0.4), lineWidth: 1)
                )

            Text("priorities.edit_hint")
                .textStyle(Theme.Typography.caption, color: Theme.Colors.outline)
        }
        .padding(Theme.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Theme.Radius.xxl, style: .continuous)
                .fill(Theme.Colors.surface)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.Radius.xxl, style: .continuous)
                .stroke(Theme.Colors.primary.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: Color(hex: 0x0F172A, opacity: 0.04), radius: 1.5, y: 1)
    }

    // MARK: Action dock

    private var actionDock: some View {
        VStack(spacing: Theme.Spacing.sm) {
            if viewModel.isEditing {
                HStack(spacing: 10) {
                    Button(action: viewModel.cancelEditing) {
                        Text("button.cancel")
                            .textStyle(Theme.Typography.bodyBold)
                            .frame(maxWidth: .infinity)
                            .frame(height: Theme.Metrics.sheetButtonHeight)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                                    .fill(Theme.Colors.surfaceContainer)
                            )
                    }
                    .buttonStyle(PressableButtonStyle())

                    Button(action: viewModel.save) {
                        HStack(spacing: 6) {
                            if viewModel.isSaving {
                                ProgressView().tint(Theme.Colors.onPrimary)
                            } else {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            Text("button.save")
                        }
                        .textStyle(Theme.Typography.bodyBold, color: Theme.Colors.onPrimary)
                        .frame(maxWidth: .infinity)
                        .frame(height: Theme.Metrics.sheetButtonHeight)
                        .background(
                            RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                                .fill(Theme.Colors.primary)
                        )
                        .shadow(color: Color(hex: 0x0F172A, opacity: 0.08), radius: 2, y: 1)
                    }
                    .buttonStyle(PressableButtonStyle())
                    .disabled(viewModel.isSaving)
                }
            } else {
                Button(action: viewModel.beginEditing) {
                    HStack(spacing: Theme.Spacing.sm) {
                        Image(systemName: "pencil")
                            .font(.system(size: 16, weight: .semibold))
                        Text("button.edit_priorities")
                    }
                    .textStyle(Theme.Typography.bodyBold, color: Theme.Colors.onPrimary)
                    .frame(maxWidth: .infinity)
                    .frame(height: Theme.Metrics.sheetButtonHeight)
                    .background(
                        RoundedRectangle(cornerRadius: Theme.Radius.xl, style: .continuous)
                            .fill(Theme.Colors.primary)
                    )
                    .shadow(color: Color(hex: 0x0F172A, opacity: 0.08), radius: 2, y: 1)
                }
                .buttonStyle(PressableButtonStyle())
            }

            Button(action: onDismiss) {
                Text("button.dismiss")
                    .textStyle(Theme.Typography.labelMd, color: Theme.Colors.onSurfaceVariant)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.Spacing.margin)
        .padding(.top, Theme.Spacing.sm)
        .padding(.bottom, Theme.Spacing.sm)
        .background(Theme.Colors.surfaceContainerLowest.opacity(0.8))
        .overlay(alignment: .top) {
            Rectangle()
                .fill(Theme.Colors.outlineVariant.opacity(0.2))
                .frame(height: 1)
        }
    }
}
