import Foundation
import OSLog
import AppModel
import SwiftUI

#if SKIP
import AndroidxComposeMaterialIcons
import AndroidxComposeMaterialIconsFilled
#endif

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


#if !SKIP
/// Returns the Icon for this tab.
///
/// On iOS returns `SwiftUI.Image`
extension AppTabs {
    var icon: Image {
        switch self {
        case .home: return Image(systemName: "house")
        case .content: return Image(systemName: "star")
        case .search: return Image(systemName: "magnifyingglass")
        case .settings: return Image(systemName: "gear")
        }
    }
}
#else
/// Returns the Icon for this tab.
///
/// On Android returns `androidx.compose.ui.graphics.vector.ImageVector`
extension AppTabs {
    var icon: androidx.compose.ui.graphics.vector.ImageVector {
        switch self {
        case .home: return Icons.Default.Home
        case .content: return Icons.Default.Star
        case .search: return Icons.Default.Search
        case .settings: return Icons.Default.Settings
        }
    }
}
#endif

