// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
#if SKIP
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
            logger.log("onCreate: SKIPKEY: \(savedInstanceState.getString("SKIPKEY"))")
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
            Manifest.permission.ACCESS_COARSE_LOCATION
            //Manifest.permission.CAMERA,
            //Manifest.permission.WRITE_EXTERNAL_STORAGE,
        )

        let requestTag = 1 // TODO: handle with onRequestPermissionsResult
        androidx.core.app.ActivityCompat.requestPermissions(self, permissions.toTypedArray(), requestTag)
    }

    public override func onSaveInstanceState(bundle: android.os.Bundle) {
        logger.log("onSaveInstanceState: \(bundle)")
        bundle.putString("SKIPKEY", Date().description)
        logger.log("onSaveInstanceState: SKIPKEY: \(bundle.getString("SKIPKEY"))")
        super.onSaveInstanceState(bundle)
    }

    public override func onRestoreInstanceState(bundle: android.os.Bundle) {
        // Usually you restore your state in onCreate(). It is possible to restore it in onRestoreInstanceState() as well, but not very common. (onRestoreInstanceState() is called after onStart(), whereas onCreate() is called before onStart().
        logger.log("onRestoreInstanceState: \(bundle)")
        super.onRestoreInstanceState(bundle)
        logger.log("onRestoreInstanceState: SKIPKEY: \(bundle.getString("SKIPKEY"))")
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

/// Returns the Icon for this tab.
/// On iOS returns `SwiftUI.Image`
/// On Android returns `androidx.compose.ui.graphics.vector.ImageVector`
extension AppTabs {
    var icon: androidx.compose.ui.graphics.vector.ImageVector {
        // call into a function because extensions don't being along imports
        iconForAppTab(tab: self)
    }
}

func iconForAppTab(tab: AppTabs) -> ImageVector {
    switch tab {
    case .home: return Icons.Default.Home
    case .device: return Icons.Default.List
    case .favorites: return Icons.Default.Star
    case .search: return Icons.Default.Search
    case .settings: return Icons.Default.Settings
    }
}

@ExperimentalMaterial3Api
@Composable func ContentView() {
    let model = Stuff()

    // SKIP INSERT: @ExperimentalMaterial3Api
    @Composable func HomeView() {
        let rows = remember { Stuff().things.toList().toMutableStateList() }
        // java.lang.IllegalArgumentException: androidx.compose.runtime.snapshots.SnapshotStateList@76feae6 cannot be saved using the current SaveableStateRegistry. The default implementation only supports types which can be stored inside the Bundle. Please consider implementing a custom Saver for this class and pass it to rememberSaveable().
        // let rows = rememberSaveable { Stuff().things.toList().toMutableStateList() }

        func addRow() {
            logger.info("Tapped add button")
            rows.add(Stuff.allThings[min(Stuff.allThings.count - 1, Array(rows).count)])
        }

        @Composable func ListView() {
            @Composable func RowView(index: Int, thing: Thing) {
                Row(modifier: Modifier.padding(6.dp),
                    verticalAlignment: Alignment.CenterVertically
                ) {
                    androidx.compose.material3.Text(text: "\(index + 1)", style: MaterialTheme.typography.bodyMedium, textAlign: TextAlign.Start, modifier: Modifier.padding(6.dp))
                    androidx.compose.material3.Text(text: "\(thing.string)", style: MaterialTheme.typography.bodyLarge, textAlign: TextAlign.Start)
                    androidx.compose.material3.Text(text: "\(Int(thing.number))", style: MaterialTheme.typography.bodyMedium, textAlign: TextAlign.End, modifier: Modifier.fillMaxWidth())
                }
            }

            LazyColumn {
                itemsIndexed(rows) { index, thing in
                    RowView(index: index, thing: thing)
                }
            }
        }

        Scaffold(topBar: {
            TopAppBar(title: {
                androidx.compose.material3.Text(text: model.title, style: MaterialTheme.typography.headlineSmall)
            },
            actions: {
                IconButton(onClick: {
                    addRow()
                }) {
                    Icon(imageVector: Icons.Default.AddCircle, contentDescription: "Add")
                }
            })
        }) { contentPadding in
            let modifier = Modifier.padding(contentPadding)
            ListView()
        }
    }

    @Composable func SearchView() {
        WebView(AppTabs.searchPage)
    }

    @Composable func WeatherView() {
        let ctx: Context = LocalContext.current
        var latitude = rememberSaveable { mutableStateOf(0.0) }
        var longitude = rememberSaveable { mutableStateOf(0.0) }

        // crashes when we try to use rememberSaveable
        var weather = remember {
            mutableStateOf(
                WeatherCondition(location: Location.default)
            )
        }

        @MainActor func fetchLocation(_ ctx: Context) async throws {
            logger.info("getting location…")
            weather.value.location.latitude = latitude.value
            weather.value.location.longitude = longitude.value
            // SKIP NOWARN
            let (lat, lon) = try await fetchCurrentLocation(ctx)
            logger.info("location: \(lat) \(lon)")
            latitude.value = lat
            longitude.value = lon
        }

        func fetchWeather() async throws {
            let w: WeatherCondition = weather.value
            let response = try await w.fetchWeather()
            if response != 200 {
                logger.log("error response: \(response)")
            } else {
                logger.log("fetched temperature: \(weather.value.temperature)")
            }
        }

        Column(horizontalAlignment: Alignment.CenterHorizontally, modifier: Modifier.fillMaxSize().padding(16.dp)) {
            Row {
                androidx.compose.material3.Text(text: "Weather", style: MaterialTheme.typography.headlineMedium, modifier: Modifier.fillMaxWidth())
            }

            @Composable func latLonField(lat: Bool) {
                TextField(
                    value: lat ? latitude.value.description : longitude.value.description,
                    onValueChange: { newValue in
                        logger.log("setting \(lat ? "latitude" : "longitude") to: \(newValue)")
                        if lat {
                            latitude.value = Double(newValue) ?? 0.0
                        } else {
                            longitude.value = Double(newValue) ?? 0.0
                        }
                    },
                    label: {
                        androidx.compose.material3.Text(lat ? "Latitude" : "Longitude")
                    },
                    keyboardOptions: KeyboardOptions(keyboardType: KeyboardType.Number)
                )
            }
            Row { latLonField(lat: true) }
            Row { latLonField(lat: false) }
            Row {
                Button(onClick: {
                    Task {
                        do {
                            try await fetchLocation(ctx)
                        } catch {
                            logger.error("error fetching location: \(error)")
                            //error.printStackTrace()
                        }
                    }
                }) { androidx.compose.material3.Text("Current Location") }
            }


            Row {
                Button(onClick: {
                    Task {
                        do {
                            try await fetchWeather()
                        } catch {
                            logger.error("error fetching data: \(error)")
                            //error.printStackTrace()
                        }
                    }
                }) { androidx.compose.material3.Text("Fetch Weather") }
            }

            if let temp = weather.value.temperature {
                Row { androidx.compose.material3.Text(text: "Temperature", style: MaterialTheme.typography.headlineMedium, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth()) }
                Row { androidx.compose.material3.Text(text: "\((temp * 9.0 / 5.0) + 32.0)°F", style: MaterialTheme.typography.headlineSmall, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth()) }
                Row { androidx.compose.material3.Text(text: "\(temp)°C", style: MaterialTheme.typography.headlineSmall, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth()) }
            }
        }
    }

    @Composable func DeviceView() {
        WeatherView()
    }

    @Composable func FavoritesView() {
        Column {
            SkipSampleView(label: "Compose").Compose()
        }
    }

    @Composable func CounterStateView() {
        //var counterToggle = mutableStateOf(false)
        //var counterToggle = remember { mutableStateOf(false) }
        var counterToggle = rememberSaveable { mutableStateOf(false) }

        Button(onClick: {
            counterToggle.value = !counterToggle.value
        }) { androidx.compose.material3.Text("Toggle") }


        @Composable func CounterView(label: String, visible: Bool) {
            //var countState = mutableStateOf(0)
            //var countState = remember { mutableStateOf(0) }
            var countState = rememberSaveable { mutableStateOf(0) }

            Button(onClick: {
                countState.value++
            }) {
                // The composite key is a unique identifier for a Composable function and its inputs. It is automatically generated by Compose based on the structure of the Composable function and the values of its input parameters. The composite key is used by Compose to efficiently track changes and update only the necessary parts of the UI.

                androidx.compose.material3.Text("\(label) \(androidx.compose.runtime.currentCompositeKeyHash): \(countState.value)", color: visible ? androidx.compose.ui.graphics.Color.White : androidx.compose.ui.graphics.Color.Yellow)
            }
        }

        Spacer(modifier: Modifier.padding(20.dp))

        Column {
            CounterView(label: "Counter A", visible: counterToggle.value)
            CounterView(label: "Counter B", visible: !counterToggle.value)
        }
    }

    @Composable func SettingsView() {
        Box(modifier: Modifier.fillMaxSize().padding(16.dp), contentAlignment: androidx.compose.ui.Alignment.Companion.Center) {
            Column {
                let context = androidx.compose.ui.platform.LocalContext.current
                let applicationId = context.packageName
                let packageInfo = context.packageManager.getPackageInfo(applicationId, 0)
                let appName = context.packageManager.getApplicationLabel(packageInfo.applicationInfo).toString()
                let versionName = packageInfo.versionName
                let versionCode = packageInfo.versionCode

                @Composable func row(_ text: String, style: TextStyle) {
                    Row(verticalAlignment: Alignment.CenterVertically, horizontalArrangement: Arrangement.End) {
                        androidx.compose.material3.Text(text: text, style: style, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())
                    }
                }

                /*
                 public final class BuildConfig {
                   public static final boolean DEBUG = Boolean.parseBoolean("true");
                   public static final String APPLICATION_ID = "com.example.emptycompose";
                   public static final String BUILD_TYPE = "debug";
                   public static final int VERSION_CODE = 1;
                   public static final String VERSION_NAME = "1.0";
                 }
                 */
                row("Name: \(appName)", style: MaterialTheme.typography.headlineSmall)
                row("ID: \(applicationId)", style: MaterialTheme.typography.headlineSmall)
                row("Version: \(versionName) \(BuildConfig.DEBUG ? "(debug)" : "(release)")", style: MaterialTheme.typography.headlineSmall)
                row("Build: \(versionCode)", style: MaterialTheme.typography.headlineSmall)

                CounterStateView()
            }
        }
    }

    @ExperimentalMaterial3Api
    @Composable func NavigationScaffold() {
        let navController = rememberNavController()

        @Composable func currentRoute(_ navController: NavHostController) -> String? {
            // In your BottomNavigation composable, get the current NavBackStackEntry using the currentBackStackEntryAsState() function. This entry gives you access to the current NavDestination. The selected state of each BottomNavigationItem can then be determined by comparing the item's route with the route of the current destination and its parent destinations (to handle cases when you are using nested navigation) via the NavDestination hierarchy.
            navController.currentBackStackEntryAsState().value?.destination?.route
        }

        Scaffold(bottomBar: {
            NavigationBar(modifier: Modifier.fillMaxWidth()) {
                AppTabs.allCases.forEachIndexed { index, tab in
                    NavigationBarItem(icon: { Icon(imageVector: tab.icon, contentDescription: tab.title) }, label: { androidx.compose.material3.Text(tab.title) }, selected: tab.rawValue == currentRoute(navController), onClick: {
                            navController.navigate(tab.rawValue) {
                                popUpTo(navController.graph.startDestinationId) {
                                    saveState = true
                                }
                                // Avoid multiple copies of the same destination when reselecting the same item
                                launchSingleTop = true
                                // Restore state when reselecting a previously selected item
                                restoreState = true
                            }
                        }
                    )
                }
            }
        }) { contentPadding in
            let modifier = Modifier.padding(contentPadding)
            NavHost(navController, startDestination: AppTabs.defaultTab.rawValue) {
                AppTabs.allCases.forEachIndexed { index, tab in
                    composable(tab.rawValue) {
                        switch tab {
                        case AppTabs.home: HomeView()
                        case AppTabs.device: DeviceView()
                        case AppTabs.favorites: FavoritesView()
                        case AppTabs.search: SearchView()
                        case AppTabs.settings: SettingsView()
                        }
                    }
                }
            }
        }
    }

    @ExperimentalMaterial3Api
    @Composable func ThemedNavigationScaffold() {
        let context: Context = LocalContext.current
        let darkMode = isSystemInDarkTheme()
        // Dynamic color is available on Android 12+
        let dynamicColor = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S

        //let colors = darkMode ? darkColors() : lightColors()
        let colorScheme = dynamicColor
            ? (darkMode ? dynamicDarkColorScheme(context) : dynamicLightColorScheme(context))
            : (darkMode ? darkColorScheme() : lightColorScheme())

        var typography = Typography(
            /* Other default text styles to override
            bodyLarge = TextStyle(
                fontFamily = FontFamily.Default,
                fontWeight = FontWeight.Normal,
                fontSize = 16.sp,
                lineHeight = 24.sp,
                letterSpacing = 0.5.sp
            )
            titleLarge = TextStyle(
                fontFamily = FontFamily.Default,
                fontWeight = FontWeight.Normal,
                fontSize = 22.sp,
                lineHeight = 28.sp,
                letterSpacing = 0.sp
            ),
            labelSmall = TextStyle(
                fontFamily = FontFamily.Default,
                fontWeight = FontWeight.Medium,
                fontSize = 11.sp,
                lineHeight = 16.sp,
                letterSpacing = 0.5.sp
            )
            */
        )

        MaterialTheme(colorScheme: colorScheme, typography: typography) {
            NavigationScaffold()
        }
    }

    ThemedNavigationScaffold()

}
#endif
