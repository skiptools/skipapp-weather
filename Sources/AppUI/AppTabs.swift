import Foundation
import OSLog
import SwiftUI

/// The logger to use for the app. Directs to the oslog on Darwin and logcat on Android.
let logger = Logger(subsystem: "app.ui", category: "AppUI")

/// The tabs for the app.
enum AppTabs : String, CaseIterable {
    /// The initial default tab shown in the app
    static let defaultTab = AppTabs.content

    case home
    case content
    case search
    case settings

    var title: LocalizedStringKey {
        switch self {
        case .home: return LocalizedStringKey("Cities")
        case .content: return LocalizedStringKey("Weather")
        case .search: return LocalizedStringKey("Search")
        case .settings: return LocalizedStringKey("Settings")
        }
    }

    /// The default web page to load on the "search" page
    static let searchPage: URL = URL(string: "https://skip.tools")!
}

