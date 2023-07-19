import Foundation
import SkipDrive

/// The name of the app's Swift target in the Package.swift
let appName = "AppUI"

/// The name of the bundle, which must match the AndroidManifest.xml
let appId = "app.ui"

/// The name of the SPM package in which this app is bundled
let packageName = "skipapp"

// Android app launcher for Skip app
#if os(macOS)
@available(macOS 13, macCatalyst 16, *)
@main public struct AndroidAppMain : GradleHarness {
    static func main() async throws {
        do {
            print("Launching App in Android Emulator (via Gradle)")
            try await AndroidAppMain().launch(appName: appName, appId: appId, packageName: packageName)
        } catch {
            print("Error launching: \(error)")
            //print("\(#file):\(#line):\(#column): error: AppDroid: \(error.localizedDescription)")
            //throw error // results in a fatalError
            exit(1)
        }
    }
}
#endif
