// swift-tools-version: 5.8
import PackageDescription
import Foundation

let modulePrefix = "WeatherApp"

let appUI = modulePrefix + "UI"
let appUITest = modulePrefix + "UITests"
let appModel = modulePrefix + "Model"
let appModelTest = modulePrefix + "ModelTests"

let skip = ProcessInfo.processInfo.environment["NOSKIP"] == nil // NOSKIP=1 env disables skip
let skipPlugin = skip ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []
let skipTest = skip ? [Target.Dependency.product(name: "SkipTest", package: "skip")] : []
let skipModel = skip ? [Target.Dependency.product(name: "SkipModel", package: "skip-model")] : []
let skipUI = skip ? [Target.Dependency.product(name: "SkipUI", package: "skip-ui")] : []
let skipDrive = skip ? [Target.Dependency.product(name: "SkipDrive", package: "skip")] : []

let package = Package(
    name: modulePrefix,
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: appUI, targets: [appUI]),
        .library(name: appModel, targets: [appModel]),
    ],
    dependencies: !skip ? [] : [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.71"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.2.1"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.2.4"),
    ],
    targets: [
        .target(name: appModel, dependencies: skipModel, path: "Sources/AppModel", resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: appModelTest, dependencies: [.target(name: appModel)] + skipTest, path: "Tests/AppModelTests", plugins: skipPlugin),
        .target(name: appUI, dependencies: [.target(name: appModel)] + skipUI, path: "Sources/AppUI", resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: appUITest, dependencies: [.target(name: appUI)] + skipTest, path: "Tests/AppUITests", plugins: skipPlugin),
    ]
)
