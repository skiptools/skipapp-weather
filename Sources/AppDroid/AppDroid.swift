import Foundation
import SkipDrive

/// The name of the app's Swift target in the Package.swift
let appName = "AppUI"

/// The name of the bundle, which must match the AndroidManifest.xml
let appId = "app.ui"

/// Set to run as a release or debug build
let appRelease = false

/// The default log levels when launching the .apk
let logLevel = [
        "\(appId):V", // all app log messages
        "\(appId).\(appName):V", // all app log messages
        "AndroidRuntime:V", // info from runtime
        "*:S", // all other log messages are silenced
]

/// To use a specific device name for launching, either specify it here or in the `SKIP_TEST_DEVICE` env property
let deviceName: String? = nil // "emulator-5554"

// Android app launcher for Skip app
#if os(macOS)
@available(macOS 13, macCatalyst 16, *)
@main public struct AndroidAppMain : GradleHarness {

    static let shared = AndroidAppMain()

    static func main() async throws {
        print("Launching App in Android Emulator (via Gradle)")
        do {
            try await shared.launch()
        } catch {
            print("Error launching: \(error)")
            throw error
        }
    }


    func launch() async throws {
        let apk = try await assemble()

        guard let fileSize = try? apk.resourceValues(forKeys: [.fileSizeKey]).fileSize else {
            throw AppLaunchError(errorDescription: "APK did not exist at path: \(apk.path)")
        }

        print("launching APK (\(ByteCountFormatter.string(fromByteCount: Int64(fileSize), countStyle: .file))): \(apk.path)")

        // select device with: SKIP_TEST_DEVICE=emulator-5554
        // this avoids the error: adb: more than one device/emulator
        var dev = ProcessInfo.processInfo.environment["SKIP_TEST_DEVICE"] ?? deviceName

        try await launchAPK(device: dev, appid: "\(appId)/.MainActivity", log: logLevel, apk: apk.path)

    }

    func assemble() async throws -> URL {
        let driver = try await GradleDriver()
        let moduleName = appName + "Kt"

        let dir = try pluginOutputFolder(moduleTranspilerFolder: moduleName + "/skip-transpiler/", linkingInto: linkFolder(forSourceFile: #file))

        let args: [String] = []
        let acts: [String] = appRelease ? ["assembleRelease"] : ["assembleDebug"]

        var exitCode: ProcessResult.ExitStatus? = nil
        let (output, _) = try await driver.launchGradleProcess(in: dir, module: appName, actions: acts, arguments: args, exitHandler: { result in
            print("GRADLE RESULT: \(result)")
            exitCode = result.exitStatus
        })

        for try await line in output {
            print("GRADLE>", line)
        }

        guard let exitCode = exitCode, case .terminated(0) = exitCode else {
            throw AppLaunchError(errorDescription: "Gradle run error: \(String(describing: exitCode))")
        }

        let path = "\(appName)/.build/\(appName)/outputs/apk/"
        let apk = appRelease ? "release/\(appName)-release.apk" : "debug/\(appName)-debug.apk"
        return URL(fileURLWithPath: path + apk, isDirectory: false, relativeTo: dir)
    }

    public func scanGradleOutput(line: String) {
        // we don't process the output for errors, so do nothing here
    }
}

public struct AppLaunchError : LocalizedError {
    public var errorDescription: String?
}
#endif

