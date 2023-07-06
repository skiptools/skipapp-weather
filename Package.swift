// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "App",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "AppUIKt", targets: ["AppUIKt"]),
        .library(name: "AppModel", targets: ["AppModel"]),
        .library(name: "AppModelKt", targets: ["AppModelKt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/skiptools/skip.git", from: "0.0.0"),
        .package(url: "https://github.com/skiptools/skiphub.git", from: "0.0.0"),
    ],
    targets: [
        // The Swift side of the app's data model
        .target(name: "AppModel",
            resources: [.process("Resources")],
            plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "AppModelTests",
            dependencies: ["AppModel"],
            plugins: [.plugin(name: "preflight", package: "skip")]),

        // The Kotlin side of the app's data model (transpiled from AppModel)
        .target(name: "AppModelKt",
            dependencies: [ "AppModel", .product(name: "SkipFoundationKt", package: "skiphub") ],
            resources: [.copy("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]
        ),
        .testTarget(name: "AppModelKtTests",
            dependencies: ["AppModelKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.copy("Skip")], plugins: [
            .plugin(name: "transpile", package: "skip")
        ]),

        // The Swift side of the app's user interface (SwiftUI)
        .target(name: "AppUI",
            dependencies: ["AppModel"],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "preflight", package: "skip")]),
        .testTarget(name: "AppUITests", dependencies: ["AppUI"],
            plugins: [.plugin(name: "preflight", package: "skip")]),

        // The Kotlin side of the app's user interface (Jetpack Compose)
        .target(name: "AppUIKt",
            dependencies: ["AppUI", "AppModelKt", .product(name: "SkipUIKt", package: "skiphub")],
            resources: [.copy("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]
        ),
        .testTarget(name: "AppUIKtTests",
            dependencies: ["AppUIKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.copy("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]),
    ]
)
