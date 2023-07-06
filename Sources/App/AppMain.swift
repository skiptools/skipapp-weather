import SwiftUI
import AppUI

/// The entry point to the app, which simply loads the `ContentView` from the `AppUI` module.
@main struct AppMain: SwiftUI.App {
    var body: some SwiftUI.Scene {
        SwiftUI.WindowGroup {
            AppUI.ContentView()
        }
    }
}
