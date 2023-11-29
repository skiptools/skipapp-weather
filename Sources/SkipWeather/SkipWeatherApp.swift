import Foundation
import OSLog
import SwiftUI

let androidSDK = ProcessInfo.processInfo.environment["android.os.Build.VERSION.SDK_INT"].flatMap({ Int($0) })
let logger = Logger(subsystem: "skip.weather.App", category: "SkipWeather")

/// The shared top-level view for the app, loaded from the platform-specific App delegates below.
///
/// The default implementation merely loads the `ContentView` for the app and logs a message.
public struct RootView : View {
    public init() {
    }

    public var body: some View {
        ContentView()
            .task {
                logger.log("Welcome to Skip on \(androidSDK != nil ? "Android" : "Darwin")!")
                logger.warning("Skip app logs are viewable in the Xcode console for iOS; Android logs can be viewed in Studio or using adb logcat")
            }
    }
}

#if !SKIP
public protocol SkipWeatherApp : App {
}

/// The entry point to the SkipWeather app.
/// The concrete implementation is in the SkipWeatherApp module.
public extension SkipWeatherApp {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

#endif
