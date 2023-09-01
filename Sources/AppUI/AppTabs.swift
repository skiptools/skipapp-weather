// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
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
        case .home: return NSLocalizedString("Cities", comment: "Home tab title")
        case .device: return NSLocalizedString("Weather", comment: "Weather tab title")
        //case .favorites: return NSLocalizedString("SkipUI", comment: "Favorites tab title")
        case .search: return NSLocalizedString("Live", comment: "Search tab title")
        case .settings: return NSLocalizedString("Settings", comment: "Settings tab title")
        }
    }

    /// The default web page to load on the "search" page
    static let searchPage: URL = URL(string: "https://skip.tools")!
}
