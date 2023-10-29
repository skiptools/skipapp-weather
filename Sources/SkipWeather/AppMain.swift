import Foundation
import OSLog
import SwiftUI
import SkipWeatherModel

/// The logger to use for the app. Directs to the oslog on Darwin and logcat on Android.
let logger = Logger(subsystem: "weather.app.ui", category: "AppUI")

/// The Android SDK number we are running against, or nil if not on Android
let androidSDK = ProcessInfo.processInfo.environment["android.os.Build.VERSION.SDK_INT"].flatMap({ Int($0) })

/// Use for application errors.
struct AppError : LocalizedError {
    var description: String
}

#if !SKIP
public protocol AppUIApp : App {
}

/// The entry point to the app, which simply loads the `ContentView` from the `AppUI` module.
public extension AppUIApp {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
#else
import android.Manifest
import android.app.Application
import androidx.activity.compose.setContent
import androidx.appcompat.app.AppCompatActivity
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.saveable.rememberSaveableStateHolder
import androidx.compose.ui.platform.LocalContext
import androidx.core.app.ActivityCompat

/// AndroidAppMain is the `android.app.Application` entry point, and must match `application android:name` in the AndroidMainfest.xml file.
public class AndroidAppMain : Application {
    public init() {
    }

    public override func onCreate() {
        super.onCreate()
        logger.info("starting app")
        logger.trace("external function: \(externalKotlinFunction())")
        ProcessInfo.launch(applicationContext)
    }
}

/// AndroidAppMain is initial `androidx.appcompat.app.AppCompatActivity`, and must match `activity android:name` in the AndroidMainfest.xml file.
@ExperimentalMaterial3Api
public class MainActivity : AppCompatActivity {
    public init() {
    }

    public override func onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        if let savedInstanceState = savedInstanceState {
            logger.info("onCreate: SAMPLE_PROP: \(savedInstanceState.getString("SAMPLE_PROP"))")
        } else {
            logger.info("onCreate")
        }

        setContent {
            let saveableStateHolder = rememberSaveableStateHolder()
            saveableStateHolder.SaveableStateProvider(true) {
                MaterialThemedContentView()
            }
        }

        let permissions = listOf(
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION
            //Manifest.permission.CAMERA,
            //Manifest.permission.WRITE_EXTERNAL_STORAGE,
        )

        let requestTag = 1 // TODO: handle with onRequestPermissionsResult
        ActivityCompat.requestPermissions(self, permissions.toTypedArray(), requestTag)
    }

    public override func onSaveInstanceState(bundle: android.os.Bundle) {
        logger.info("onSaveInstanceState: \(bundle)")
        bundle.putString("SAMPLE_PROP", Date().description)
        logger.info("onSaveInstanceState: SAMPLE_PROP: \(bundle.getString("SAMPLE_PROP"))")
        super.onSaveInstanceState(bundle)
    }

    public override func onRestoreInstanceState(bundle: android.os.Bundle) {
        // Usually you restore your state in onCreate(). It is possible to restore it in onRestoreInstanceState() as well, but not very common. (onRestoreInstanceState() is called after onStart(), whereas onCreate() is called before onStart().
        logger.info("onRestoreInstanceState: \(bundle)")
        super.onRestoreInstanceState(bundle)
        logger.info("onRestoreInstanceState: SAMPLE_PROP: \(bundle.getString("SAMPLE_PROP"))")
    }

    public override func onRestart() {
        logger.info("onRestart")
        super.onRestart()
    }

    public override func onStart() {
        logger.info("onStart")
        super.onStart()
    }

    public override func onResume() {
        logger.info("onResume")
        super.onResume()
    }

    public override func onPause() {
        logger.info("onPause")
        super.onPause()
    }

    public override func onStop() {
        logger.info("onStop")
        super.onStop()
    }

    public override func onDestroy() {
        logger.info("onDestroy")
        super.onDestroy()
    }

    public override func onRequestPermissionsResult(requestCode: Int, permissions: kotlin.Array<String>, grantResults: IntArray) {
        logger.info("onRequestPermissionsResult: \(requestCode)")
    }
}

@ExperimentalMaterial3Api
@Composable func MaterialThemedContentView() {
    let context = LocalContext.current
    let darkMode = isSystemInDarkTheme()
    // Dynamic color is available on Android 12+
    let dynamicColor = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S

    let colorScheme = dynamicColor
        ? (darkMode ? dynamicDarkColorScheme(context) : dynamicLightColorScheme(context))
        : (darkMode ? darkColorScheme() : lightColorScheme())

    MaterialTheme(colorScheme: colorScheme) {
        ContentView().Compose()
    }
}
#endif
