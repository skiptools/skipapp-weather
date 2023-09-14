// swift-tools-version: 5.8
import PackageDescription

let skip = true
let skipPlugin = skip ? [Target.PluginUsage.plugin(name: "skipstone", package: "skip")] : []
let skipCondition = TargetDependencyCondition.when(platforms: skip ? [.macOS] : [])

let skipTest = Target.Dependency.product(name: "SkipTest", package: "skip") // , condition: skipCondition)
let skipModel = Target.Dependency.product(name: "SkipModel", package: "skip-model") // , condition: skipCondition)
let skipUI = Target.Dependency.product(name: "SkipUI", package: "skip-ui") // , condition: skipCondition)

let package = Package(
    name: "App",
    defaultLocalization: "en",
    platforms: [.macOS("13"), .iOS("16")],
    products: [
        .library(name: "AppUI", targets: ["AppUI"]),
        .library(name: "AppModel", targets: ["AppModel"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/skip.git", from: "0.6.70"),
        .package(url: "https://source.skip.tools/skip-model.git", from: "0.2.0"),
        .package(url: "https://source.skip.tools/skip-ui.git", from: "0.1.22"),
    ],
    targets: [
        .executableTarget(name: "AppDroid", dependencies: ["AppUI", .product(name: "SkipDrive", package: "skip")]),

        // The Swift side of the app's data model
        .target(name: "AppModel", dependencies: [skipModel], resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: "AppModelTests", dependencies: ["AppModel", skipTest], plugins: skipPlugin),

        // The Swift side of the app's user interface (SwiftUI)
        .target(name: "AppUI", dependencies: ["AppModel", skipUI], resources: [.process("Resources")], plugins: skipPlugin),
        .testTarget(name: "AppUITests", dependencies: ["AppUI", skipTest], plugins: skipPlugin),
    ]
)
