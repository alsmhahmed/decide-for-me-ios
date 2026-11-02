//
//  AppLanguage.swift
//  DecideForMe
//
//  In-app language selection ("en" / "ar"), persisted with @AppStorage("appLanguage").
//

import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case arabic = "ar"

    static let storageKey = "appLanguage"

    var id: String { rawValue }

    /// Native names are intentionally NOT localized.
    var nativeName: String {
        switch self {
        case .english: return "English"
        case .arabic: return "العربية"
        }
    }

    var layoutDirection: LayoutDirection {
        self == .arabic ? .rightToLeft : .leftToRight
    }
}

/// Applies the selected language (locale + layout direction) to a view tree.
/// Used at the root and again inside sheets so presentations always match.
struct AppLanguageModifier: ViewModifier {
    @AppStorage(AppLanguage.storageKey) private var appLanguage = AppLanguage.english.rawValue

    func body(content: Content) -> some View {
        content
            .environment(\.locale, Locale(identifier: appLanguage))
            .environment(\.layoutDirection, appLanguage == "ar" ? .rightToLeft : .leftToRight)
    }
}

extension View {
    func applyAppLanguage() -> some View { modifier(AppLanguageModifier()) }
}

/// Resolves strings outside of SwiftUI `Text` (view models, services) using the
/// language selected in the app, not the device language.
enum L10n {
    static var currentLanguage: String {
        UserDefaults.standard.string(forKey: AppLanguage.storageKey) ?? AppLanguage.english.rawValue
    }

    static func string(_ key: String.LocalizationValue) -> String {
        let code = currentLanguage
        let bundle = Bundle.main.path(forResource: code, ofType: "lproj").flatMap(Bundle.init(path:)) ?? .main
        return String(localized: key, bundle: bundle, locale: Locale(identifier: code))
    }
}
