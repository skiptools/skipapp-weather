// swift-tools-version: 5.9
// This is a Skip (https://skip.tools) package,
// containing a Swift Package Manager project
// that will use the Skip build plugin to transpile the
// Swift Package, Sources, and Tests into an
// Android Gradle Project with Kotlin sources and JUnit tests.
import PackageDescription
import Foundation

// Set SKIP_ZERO=1 to build without Skip libraries
let zero = ProcessInfo.processInfo.environment["SKIP_ZERO"] != nil
let skipstone = !zero ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []

let package = Package(
    name: "skipapp-weather",
    defaultLocalization: "en",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .macCatalyst(.v16)],
    products: [
        .library(name: "SkipWeatherApp", type: .dynamic, targets: ["SkipWeather"]),
        .library(name: "SkipWeatherModel", type: .dynamic, targets: ["SkipWeatherModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.9.2"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.10.0"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.7.0"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.8.0")
    ],
    targets: [
        .target(name: "SkipWeather", dependencies: ["SkipWeatherModel"] + (zero ? [] : [.product(name: "SkipUI", package: "skip-ui")]), resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipWeatherTests", dependencies: ["SkipWeather"] + (zero ? [] : [.product(name: "SkipTest", package: "skip")]), resources: [.process("Resources")], plugins: skipstone),
        .target(name: "SkipWeatherModel", dependencies: (zero ? [] : [.product(name: "SkipFoundation", package: "skip-foundation"), .product(name: "SkipModel", package: "skip-model")]), resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipWeatherModelTests", dependencies: ["SkipWeatherModel"] + (zero ? [] : [.product(name: "SkipTest", package: "skip")]), resources: [.process("Resources")], plugins: skipstone),
    ]
)
