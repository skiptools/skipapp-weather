// swift-tools-version: 5.8
import PackageDescription

import class Foundation.ProcessInfo

// Disable Skip by setting NOSKIP
let skip = ProcessInfo.processInfo.environment["NOSKIP"] == nil

let skipPlugin = skip ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []
let skipTest = skip ? [Target.Dependency.product(name: "SkipTest", package: "skip")] : []
let skipModel = skip ? [Target.Dependency.product(name: "SkipModel", package: "skip-model")] : []
let skipUI = skip ? [Target.Dependency.product(name: "SkipUI", package: "skip-ui")] : []
let skipDrive = skip ? [Target.Dependency.product(name: "SkipDrive", package: "skip")] : []

let package = Package(
    name: "App",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "AppModel", targets: ["AppModel"]),
    ],
    dependencies: !skip ? [] : [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.70"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.2.0"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.1.22"),
    ],
    targets: [
        // The Swift side of the app's data model
        .target(name: "AppModel", dependencies: skipModel, resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: "AppModelTests", dependencies: ["AppModel"] + skipTest, plugins: skipPlugin),

        // The Swift side of the app's user interface (SwiftUI)
        .target(name: "AppUI", dependencies: ["AppModel"] + skipUI, resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: "AppUITests", dependencies: ["AppUI"] + skipTest, plugins: skipPlugin),

        .executableTarget(name: "AppDroid", dependencies: ["AppUI"] + skipDrive),
    ]
)
