import Foundation
import OSLog
import AppModel

/// The logger to use for the app. Directs to the system log on Darwin and logcat on Android.
let logger = Logger(subsystem: "app.ui", category: "AppUI")

/// The tabs for the app.
enum AppTabs : String, CaseIterable {
    case home
    case device
    case favorites
    case search
    case settings

    var title: String {
        switch self {
        case .home: return NSLocalizedString("Home", comment: "Home tab title")
        case .device: return NSLocalizedString("Browse", comment: "Device tab title")
        case .favorites: return NSLocalizedString("Favorites", comment: "Favorites tab title")
        case .search: return NSLocalizedString("Search", comment: "Search tab title")
        case .settings: return NSLocalizedString("Settings", comment: "Settings tab title")
        }
    }

    /// The default web page to load on the "search" page
    static let searchPage: URL = URL(string: "https://skip.tools")!
}
