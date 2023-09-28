// swift-tools-version: 5.8
import PackageDescription
import Foundation

// This is a Skip App Package for a dual-platform iOS/Android app.
// It is meant to be paired with an App.xcconfig file  and "ModuleName".xcodeproj folder.
let modulePrefix = "WeatherApp"

let appUI = modulePrefix + "UI"
let appUITest = appUI + "Tests"
let appModel = modulePrefix + "Model"
let appModelTest = appModel + "Tests"

let skip = ProcessInfo.processInfo.environment["NOSKIP"] == nil // NOSKIP=1 disables skip
let skipPlugin = skip ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []
let skipTest = skip ? [Target.Dependency.product(name: "SkipTest", package: "skip")] : []
let skipModel = skip ? [Target.Dependency.product(name: "SkipModel", package: "skip-model")] : []
let skipFoundation = skip ? [Target.Dependency.product(name: "SkipFoundation", package: "skip-foundation")] : []
let skipUI = skip ? [Target.Dependency.product(name: "SkipUI", package: "skip-ui")] : []
let skipDrive = skip ? [Target.Dependency.product(name: "SkipDrive", package: "skip")] : []

let package = Package(
    name: modulePrefix,
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        // The top-level "AppModule" constant must target all the app's modules
        .library(name: "AppModule", type: .dynamic, targets: [appUI, appModel]),
        .library(name: appUI, targets: [appUI]),
        .library(name: appModel, targets: [appModel]),
    ],
    dependencies: !skip ? [] : [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.78"),
        .package(url: "https://source.skip.tools/skip-foundation.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.2.11"),
    ],
    targets: [
        .target(name: appModel, dependencies: skipModel + skipFoundation, path: "Sources/AppModel", resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: appModelTest, dependencies: [.target(name: appModel)] + skipTest, path: "Tests/AppModelTests", plugins: skipPlugin),
        .target(name: appUI, dependencies: [.target(name: appModel)] + skipUI, path: "Sources/AppUI", resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: appUITest, dependencies: [.target(name: appUI)] + skipTest, path: "Tests/AppUITests", plugins: skipPlugin),
    ]
)
