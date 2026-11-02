//
//  DecideForMeApp.swift
//  DecideForMe
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

@main
struct DecideForMeApp: App {
    init() {
        #if DEBUG
        // App Check debug provider must be installed before FirebaseApp.configure().
        let providerFactory = AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(providerFactory)
        #endif

        FirebaseApp.configure()
        FontLoader.register()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .applyAppLanguage()   // locale + layoutDirection from @AppStorage("appLanguage")
                .preferredColorScheme(.light)
        }
    }
}
