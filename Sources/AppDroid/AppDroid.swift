#if canImport(SkipDrive)
import Foundation
import SkipDrive

/// The name of the app's Swift target in the Package.swift
let appName = "AppUI"

/// The name of the SPM package in which this app is bundled
let packageName = "skipapp-weather"

// Android app launcher for Skip app
@available(macOS 13, macCatalyst 16, *)
@main public struct AndroidAppMain : GradleHarness {
    static func main() async throws {
        do {
            print("Launching App in Android Emulator (via Gradle)")
            let appId = ProcessInfo.processInfo.environment["PRODUCT_BUNDLE_IDENTIFIER"] ?? "app.ui"
            try await AndroidAppMain().launch(appName: appName, appId: appId, packageName: packageName)
        } catch {
            print("Error launching: \(error)")
            exit(1)
        }
    }
}
#endif
