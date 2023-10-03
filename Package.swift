// swift-tools-version: 5.9
import PackageDescription
import Foundation

// Run with NOSKIP=1 environment to exclude Skip libraries
let noskip = ProcessInfo.processInfo.environment["NOSKIP"] != nil
let skip: TargetDependencyCondition? = noskip ? .when(platforms: [.android]) : nil
let plugin: [Target.PluginUsage] = noskip ? [] : [.plugin(name: "skipstone", package: "skip")]

let package = Package(
    name: "WeatherApp",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "WeatherApp", targets: ["WeatherAppUI", "WeatherAppModel"]),
        .library(name: "WeatherAppUI", targets: ["WeatherAppUI"]),
        .library(name: "WeatherAppModel", targets: ["WeatherAppModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.78"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.2.11"),
    ],
    targets: [
        .target(name: "WeatherAppUI", dependencies: [
            "WeatherAppModel",
            .product(name: "SkipUI", package: "skip-ui", condition: skip)
        ], path: "Sources/AppUI", resources: [.process("Resources")], plugins: plugin),
        .testTarget(name: "WeatherAppUITests", dependencies: [
            "WeatherAppUI",
            .product(name: "SkipTest", package: "skip", condition: skip)
        ], path: "Tests/AppUITests", plugins: plugin),

        .target(name: "WeatherAppModel", dependencies: [
            .product(name: "SkipModel", package: "skip-model", condition: skip),
            .product(name: "SkipFoundation", package: "skip-foundation", condition: skip)
        ], path: "Sources/AppModel", resources: [.process("Resources")], plugins: plugin),
        .testTarget(name: "WeatherAppModelTests", dependencies: [
            "WeatherAppModel",
            .product(name: "SkipTest", package: "skip", condition: skip)
        ], path: "Tests/AppModelTests", plugins: plugin),
    ]
)
