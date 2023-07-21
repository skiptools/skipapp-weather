// swift-tools-version: 5.8
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
        .package(url: "https://skip.tools/skiptools/skip.git", from: "0.5.13"),
        .package(url: "https://github.com/skiptools/skiphub.git", from: "0.4.10"),
    ],
    targets: [
        .executableTarget(name: "AppDroid", dependencies: [ "AppUIKt", .product(name: "SkipDrive", package: "skip") ]),

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
            resources: [.process("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]),
        .testTarget(name: "AppModelKtTests",
            dependencies: ["AppModelKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.process("Skip")], plugins: [
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
            dependencies: ["AppUI", "AppModel", "AppModelKt", .product(name: "SkipUIKt", package: "skiphub")],
            resources: [.process("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip"), .plugin(name: "skipbuild", package: "skip")]
        ),
        .testTarget(name: "AppUIKtTests",
            dependencies: ["AppUIKt", .product(name: "SkipUnitKt", package: "skiphub")], resources: [.process("Skip")],
            plugins: [.plugin(name: "transpile", package: "skip")]),
    ]
)

import class Foundation.ProcessInfo
// For Skip library development in peer directories, run: SKIPLOCAL=.. xed Package.swift
if let localPath = ProcessInfo.processInfo.environment["SKIPLOCAL"] {
    package.dependencies[0] = .package(path: localPath + "/skip")
    package.dependencies[1] = .package(path: localPath + "/skiphub")
}
