import Foundation
import OSLog
import AppModel

/// The logger to use for the app. Directs to the oslog on Darwin and logcat on Android.
let logger = Logger(subsystem: "app.ui", category: "AppUI")

/// The tabs for the app.
enum AppTabs : String, CaseIterable {
    /// The initial default tab shown in the app
    static let defaultTab = AppTabs.home

    case home
    case device
    //case favorites
    case search
    case settings

    var title: String {
        switch self {
        case .home: return NSLocalizedString("Cities", bundle: .module, comment: "Home tab title")
        case .device: return NSLocalizedString("Weather", bundle: .module, comment: "Weather tab title")
        //case .favorites: return NSLocalizedString("SkipUI", bundle: .module, comment: "Favorites tab title")
        case .search: return NSLocalizedString("Live", bundle: .module, comment: "Search tab title")
        case .settings: return NSLocalizedString("Settings", bundle: .module, comment: "Settings tab title")
        }
    }

    /// The default web page to load on the "search" page
    static let searchPage: URL = URL(string: "https://skip.tools")!
}
