// swift-tools-version: 5.9
import PackageDescription
import Foundation

// Set SKIP_ZERO=1 to build without Skip libraries
let zero = ProcessInfo.processInfo.environment["SKIP_ZERO"] != nil
let skipstone = !zero ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []

let package = Package(
    name: "skipapp-weather",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "SkipWeather", type: .dynamic, targets: ["SkipWeather"]),
        .library(name: "SkipWeatherModel", type: .dynamic, targets: ["SkipWeatherModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.78"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.2.11"),
    ],
    targets: [
        .target(name: "SkipWeather", dependencies: [
            "SkipWeatherModel"
            ] + (zero ? [] : [.product(name: "SkipUI", package: "skip-ui")]),
        resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipWeatherTests", dependencies: [
            "SkipWeather"
        ] + (zero ? [] : [
            .product(name: "SkipTest", package: "skip")
        ]), plugins: skipstone),

        .target(name: "SkipWeatherModel", dependencies: (zero ? [] : [
            .product(name: "SkipModel", package: "skip-model"),
            .product(name: "SkipFoundation", package: "skip-foundation")
        ]), resources: [.process("Resources")], plugins: skipstone),
        .testTarget(name: "SkipWeatherModelTests", dependencies: [
            "SkipWeatherModel"
        ] + (zero ? [] : [
            .product(name: "SkipTest", package: "skip")
        ]), plugins: skipstone),
    ]
)
