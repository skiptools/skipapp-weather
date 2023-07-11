import Foundation
import OSLog
import AppModel

let logger = Logger(subsystem: "app.ui", category: "AppUI")

/// The tabs for the app
enum AppTabs : String, CaseIterable {
    case home
    case search
    case settings

    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .settings: return "Settings"
        }
    }
}
