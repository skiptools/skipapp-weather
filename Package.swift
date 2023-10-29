// swift-tools-version: 5.9
import PackageDescription
import Foundation

// Set SKIP_ZERO=1 to build without Skip libraries
let zero = ProcessInfo.processInfo.environment["SKIP_ZERO"] != nil
let skip = zero ? TargetDependencyCondition.when(platforms: [.android]) : .none
let plugin = !zero ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []

let package = Package(
    name: "skipapp-weather",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "SkipWeather", targets: ["SkipWeather"]),
        .library(name: "SkipWeatherModel", targets: ["SkipWeatherModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.78"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.2.11"),
    ],
    targets: [
        .target(name: "SkipWeather", dependencies: [
            "SkipWeatherModel",
            .product(name: "SkipUI", package: "skip-ui", condition: skip)
        ], resources: [.process("Resources")], plugins: plugin),
        .testTarget(name: "SkipWeatherTests", dependencies: [
            "SkipWeather",
            .product(name: "SkipTest", package: "skip", condition: skip)
        ], plugins: plugin),

        .target(name: "SkipWeatherModel", dependencies: [
            .product(name: "SkipModel", package: "skip-model", condition: skip),
            .product(name: "SkipFoundation", package: "skip-foundation", condition: skip)
        ], resources: [.process("Resources")], plugins: plugin),
        .testTarget(name: "SkipWeatherModelTests", dependencies: [
            "SkipWeatherModel",
            .product(name: "SkipTest", package: "skip", condition: skip)
        ], plugins: plugin),
    ]
)
