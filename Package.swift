// swift-tools-version: 5.8
import PackageDescription

let package = Package(
    name: "App",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "AppModel", targets: ["AppModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.28"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.1.6"),
    ],
    targets: [
        .executableTarget(name: "AppDroid",
            dependencies: ["AppUI", .product(name: "SkipDrive", package: "skip")]),

        // The Swift side of the app's data model
        .target(name: "AppModel",
            dependencies: [.product(name: "SkipUI", package: "skip-ui", condition: .when(platforms: [.macOS]))],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "AppModelTests",
            dependencies: [
                "AppModel",
                .product(name: "SkipUI", package: "skip-ui")
            ],
            plugins: [.plugin(name: "skipstone", package: "skip")]),

        // The Swift side of the app's user interface (SwiftUI)
        .target(name: "AppUI",
            dependencies: [
                "AppModel",
            ],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
        .testTarget(name: "AppUITests", dependencies: ["AppUI"],
            plugins: [.plugin(name: "skipstone", package: "skip")]),
    ]
)
