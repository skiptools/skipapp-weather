import SkipUnit

#if os(Android) || os(macOS) || os(Linux) || targetEnvironment(macCatalyst)

/// This test case will run the transpiled tests for the Skip module.
@available(macOS 13, macCatalyst 16, *)
final class AppKtTests: XCTestCase, XCGradleHarness {
    /// This test case will run the transpiled tests defined in the Swift peer module.
    /// New tests should be added there, not here.
    public func testSkipModule() async throws {
        // run the tests, and also build the APK at:
        // Packages/Skip/skipapp.output/AppUIKtTests/skip-transpiler/AppUI/.build/AppUI/outputs/apk/debug/AppUI-debug.apk
        // Packages/Skip/skipapp.output/AppUIKtTests/skip-transpiler/AppUI/.build/AppUI/outputs/apk/release/AppUI-release-unsigned.apk

        // build will run both assembleDebug and assembleRelease
        try await gradle(actions: ["build"], moduleName: "AppUIKtTests")


        // select device with: SKIP_TEST_DEVICE=emulator-5554
        // this avoids the error: adb: more than one device/emulator
        let dev = ProcessInfo.processInfo.environment["SKIP_TEST_DEVICE"]
        //dev = dev ?? "emulator-5554"
        if let device = dev {
            //try await gradle(actions: ["assembleDebug"], moduleName: "AppUIKtTests")

            // Verbose/Debug/Info/Warn/Error/Fatal/Silent
            // be verbose with "app.demo:V" and silence everything else ("*:S")
            // Uncaught stack traces go to "AndroidRuntime:V"

            // FIXME: ADB> adb: failed to install /opt/src/github/skiptools/skipapp/Packages/Skip/skipapp.output/AppUIKtTests/skip-transpiler/AppUI/.build/AppUI/outputs/apk/release/AppUI-release-unsigned.apk: Failure [INSTALL_PARSE_FAILED_NO_CERTIFICATES: Failed to collect certificates from /data/app/vmdl1452858066.tmp/base.apk: Attempt to get length of null array]
            //let apk = "Packages/Skip/skipapp.output/AppUIKtTests/skip-transpiler/AppUI/.build/AppUI/outputs/apk/release/AppUI-release-unsigned.apk"
            let apk = "Packages/Skip/skipapp.output/AppUIKtTests/skip-transpiler/AppUI/.build/AppUI/outputs/apk/debug/AppUI-debug.apk"

            try await launchAPK(device: device, appid: "app.demo/.MainActivity", log: ["app.demo:V", "app.demo.App:V", "AndroidRuntime:V", "*:S"],
                apk: apk)
        } else {
            try await gradle(actions: ["testDebug"])
        }
    }
}

#endif
