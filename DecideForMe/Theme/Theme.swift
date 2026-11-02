//
//  Theme.swift
//  DecideForMe
//
//  Single source of truth for colors, typography, spacing and corner radii.
//  Values are taken verbatim from the Stitch "Decide For Me" design system.
//

import SwiftUI
import CoreText

// MARK: - Hex helper

extension Color {
    init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

enum Theme {

    // MARK: Colors

    enum Colors {
        static let surface = Color(hex: 0xF9F9FF)
        static let background = Color(hex: 0xF9F9FF)
        static let surfaceContainerLowest = Color(hex: 0xFFFFFF)
        static let surfaceContainerLow = Color(hex: 0xF0F3FF)
        static let surfaceContainer = Color(hex: 0xE7EEFF)
        static let surfaceContainerHigh = Color(hex: 0xDEE8FF)
        static let surfaceContainerHighest = Color(hex: 0xD8E3FB)

        static let onSurface = Color(hex: 0x111C2D)
        static let onSurfaceVariant = Color(hex: 0x464555)
        static let inverseSurface = Color(hex: 0x263143)

        static let outline = Color(hex: 0x777587)
        static let outlineVariant = Color(hex: 0xC7C4D8)

        static let primary = Color(hex: 0x3525CD)
        static let onPrimary = Color(hex: 0xFFFFFF)
        static let primaryContainer = Color(hex: 0x4F46E5)
        static let primaryFixed = Color(hex: 0xE2DFFF)
        static let secondary = Color(hex: 0x4648D4)
        static let error = Color(hex: 0xBA1A1A)
    }

    // MARK: Spacing

    enum Spacing {
        static let xs: CGFloat = 4      // space-xs  0.25rem
        static let sm: CGFloat = 8      // space-sm  0.5rem
        static let md: CGFloat = 16     // space-md / gutter 1rem
        static let lg: CGFloat = 24     // space-lg  1.5rem
        static let xl: CGFloat = 36     // space-xl  2.25rem
        static let margin: CGFloat = 20 // margin    1.25rem
    }

    // MARK: Corner radii (as used by the Stitch screens)

    enum Radius {
        static let small: CGFloat = 4     // DEFAULT / bubble "tail" corner
        static let lg: CGFloat = 8
        static let xl: CGFloat = 12       // inputs, buttons
        static let xxl: CGFloat = 16      // bubbles, cards
        static let xxxl: CGFloat = 24     // docked footer
        static let sheet: CGFloat = 28    // bottom sheet
    }

    // MARK: Layout metrics

    enum Metrics {
        static let inputHeight: CGFloat = 44
        static let primaryButtonHeight: CGFloat = 54
        static let sheetButtonHeight: CGFloat = 50
        static let avatarSize: CGFloat = 32
    }

    // MARK: Typography

    struct TextStyle {
        let size: CGFloat
        let weight: Font.Weight
        let lineHeight: CGFloat
        let letterSpacingEm: CGFloat

        var font: Font { .custom(FontLoader.family, size: size).weight(weight) }
        var tracking: CGFloat { size * letterSpacingEm }
        var lineSpacing: CGFloat { max(0, lineHeight - size * 1.21) }
    }

    enum Typography {
        static let displayLg  = TextStyle(size: 36, weight: .bold,     lineHeight: 44, letterSpacingEm: -0.03)
        static let headlineLg = TextStyle(size: 30, weight: .semibold, lineHeight: 36, letterSpacingEm: -0.025)
        static let headlineMd = TextStyle(size: 24, weight: .semibold, lineHeight: 30, letterSpacingEm: -0.02)
        static let headlineSm = TextStyle(size: 20, weight: .semibold, lineHeight: 26, letterSpacingEm: -0.015)
        static let bodyLg     = TextStyle(size: 17, weight: .regular,  lineHeight: 24, letterSpacingEm: -0.01)
        static let bodyMd     = TextStyle(size: 15, weight: .regular,  lineHeight: 22, letterSpacingEm: -0.005)
        static let bodyBold   = TextStyle(size: 15, weight: .semibold, lineHeight: 22, letterSpacingEm: -0.005)
        static let labelLg    = TextStyle(size: 13, weight: .semibold, lineHeight: 18, letterSpacingEm: 0.01)
        static let labelMd    = TextStyle(size: 12, weight: .medium,   lineHeight: 16, letterSpacingEm: 0.02)
        static let caption    = TextStyle(size: 11, weight: .medium,   lineHeight: 14, letterSpacingEm: 0.03)
    }
}

// MARK: - Inter font registration

enum FontLoader {
    static let family = "Inter"

    /// Registers the bundled Inter variable font once at launch.
    static func register() {
        guard let url = Bundle.main.url(forResource: "Inter", withExtension: "ttf")
                ?? Bundle.main.url(forResource: "Inter", withExtension: "ttf", subdirectory: "Fonts")
        else { return }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}

// MARK: - View modifiers

extension View {
    /// Applies a design-system text style (font, tracking, line height).
    /// Arabic falls back to the system font because Inter has no Arabic glyphs.
    func textStyle(_ style: Theme.TextStyle, color: Color = Theme.Colors.onSurface) -> some View {
        modifier(TextStyleModifier(style: style, color: color))
    }
}

private struct TextStyleModifier: ViewModifier {
    @Environment(\.locale) private var locale
    let style: Theme.TextStyle
    let color: Color

    private var isArabic: Bool { locale.language.languageCode?.identifier == "ar" }

    func body(content: Content) -> some View {
        content
            .font(isArabic ? .system(size: style.size, weight: style.weight) : style.font)
            .tracking(isArabic ? 0 : style.tracking)
            .lineSpacing(isArabic ? style.lineSpacing + 2 : style.lineSpacing)
            .foregroundStyle(color)
    }
}

/// Pressed-state scale (0.98) used by all buttons in the design.
struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}
