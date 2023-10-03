// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WeatherApp",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "WeatherApp", type: .dynamic, targets: ["WeatherAppUI", "WeatherAppModel"]),
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
            .product(name: "SkipUI", package: "skip-ui")
        ], path: "Sources/AppUI", resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "WeatherAppUITests", dependencies: [
            "WeatherAppUI",
            .product(name: "SkipTest", package: "skip")
        ], path: "Tests/AppUITests", plugins: [.plugin(name: "skipstone", package: "skip")]),

        .target(name: "WeatherAppModel", dependencies: [
            .product(name: "SkipModel", package: "skip-model"),
            .product(name: "SkipFoundation", package: "skip-foundation")
        ], path: "Sources/AppModel", resources: [.process("Resources")], plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "WeatherAppModelTests", dependencies: [
            "WeatherAppModel",
            .product(name: "SkipTest", package: "skip")
        ], path: "Tests/AppModelTests", plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
