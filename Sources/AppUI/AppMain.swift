#if !SKIP
import Foundation
import AppModel
import SwiftUI

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

import AppModel
import Foundation
import SwiftUI

import Android
import AndroidApp
import AndroidContent.Context
import AndroidxAppcompatApp
import AndroidxActivityCompose
import AndroidxComposeRuntime
import AndroidxComposeRuntimeSaveable
import AndroidxComposeMaterial3
import AndroidxComposeMaterialIcons
import AndroidxComposeMaterialIconsFilled
import AndroidxComposeFoundation
import AndroidxComposeFoundationShape
import AndroidxComposeFoundationLayout
import AndroidxComposeFoundationLazy
import AndroidxComposeFoundationLazy.items
import AndroidxComposeFoundationLazy.itemsIndexed
import AndroidxComposeFoundationText
import AndroidxComposeUi
import AndroidxComposeUiGeometry
import AndroidxComposeUiGraphics
import AndroidxComposeUiGraphicsVector
import AndroidxComposeUiLayout
import AndroidxComposeUiPlatform
import AndroidxComposeUiText
import AndroidxComposeUiTextFont
import AndroidxComposeUiTextInput
import AndroidxComposeUiTextStyle
import AndroidxComposeUiToolingPreview
import AndroidxComposeUiUnit
import AndroidxNavigation
import AndroidxNavigationCompose

/// AndroidAppMain is the `android.app.Application` entry point, and must match `application android:name` in the AndroidMainfest.xml file
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

/// AndroidAppMain is initial `androidx.appcompat.app.AppCompatActivity`, and must match `activity android:name` in the AndroidMainfest.xml file
public class MainActivity : AppCompatActivity {
    public init() {
    }

    @ExperimentalMaterial3Api
    public override func onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        if let savedInstanceState = savedInstanceState {
            logger.log("onCreate: SAMPLE_PROP: \(savedInstanceState.getString("SAMPLE_PROP"))")
        } else {
            logger.log("onCreate")
        }

        setContent {
            let saveableStateHolder = rememberSaveableStateHolder()
            saveableStateHolder.SaveableStateProvider("ABC") {
                ContentView()
            }
        }

        let permissions = listOf(
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION
            //Manifest.permission.CAMERA,
            //Manifest.permission.WRITE_EXTERNAL_STORAGE,
        )

        let requestTag = 1 // TODO: handle with onRequestPermissionsResult
        androidx.core.app.ActivityCompat.requestPermissions(self, permissions.toTypedArray(), requestTag)
    }

    public override func onSaveInstanceState(bundle: android.os.Bundle) {
        logger.log("onSaveInstanceState: \(bundle)")
        bundle.putString("SAMPLE_PROP", Date().description)
        logger.log("onSaveInstanceState: SAMPLE_PROP: \(bundle.getString("SAMPLE_PROP"))")
        super.onSaveInstanceState(bundle)
    }

    public override func onRestoreInstanceState(bundle: android.os.Bundle) {
        // Usually you restore your state in onCreate(). It is possible to restore it in onRestoreInstanceState() as well, but not very common. (onRestoreInstanceState() is called after onStart(), whereas onCreate() is called before onStart().
        logger.log("onRestoreInstanceState: \(bundle)")
        super.onRestoreInstanceState(bundle)
        logger.log("onRestoreInstanceState: SAMPLE_PROP: \(bundle.getString("SAMPLE_PROP"))")
    }


    public override func onRestart() {
        logger.log("onRestart")
        super.onRestart()
    }

    public override func onStart() {
        logger.log("onStart")
        super.onStart()
    }

    public override func onResume() {
        logger.log("onResume")
        super.onResume()
    }

    public override func onPause() {
        logger.log("onPause")
        super.onPause()
    }

    public override func onStop() {
        logger.log("onStop")
        super.onStop()
    }

    public override func onDestroy() {
        logger.log("onDestroy")
        super.onDestroy()
    }

    public override func onRequestPermissionsResult(requestCode: Int, permissions: kotlin.Array<String>, grantResults: IntArray) {
        logger.info("onRequestPermissionsResult: \(requestCode)")
    }
}

#endif
