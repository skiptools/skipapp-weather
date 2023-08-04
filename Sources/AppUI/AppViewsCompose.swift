#if SKIP
import Foundation
import AppModel

import Android
import AndroidApp
import AndroidContent.Context
import AndroidxAppcompatApp
import AndroidxActivityCompose
import AndroidxComposeRuntime
import AndroidxComposeMaterial
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

    // SKIP INSERT: @ExperimentalMaterialApi
    public override func onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ContentView()
        }

        let permissions = listOf(
            Manifest.permission.ACCESS_COARSE_LOCATION
            //Manifest.permission.CAMERA,
            //Manifest.permission.WRITE_EXTERNAL_STORAGE,
        )

        let requestTag = 1 // TODO: handle with onRequestPermissionsResult
        androidx.core.app.ActivityCompat.requestPermissions(self, permissions.toTypedArray(), requestTag)
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

// SKIP INSERT: @Preview(name = "Light theme")
// SKIP INSERT: @Preview(name = "Dark theme")
// SKIP INSERT: @ExperimentalMaterialApi
// SKIP INSERT: @Composable
func ContentView() -> Void {
    let model = Stuff()
    let rows = remember { Stuff().things.toList().toMutableStateList() }
    var selectedTab = remember { mutableStateOf(AppTabs.defaultTab) }

    func addRow() {
        logger.info("Tapped add button")
        rows.add(Stuff.allThings[min(Stuff.allThings.count - 1, Array(rows).count)])
    }

    // SKIP INSERT: @Composable
    func RowView(index: Int, thing: Thing) -> Void {
        Row(modifier: Modifier.padding(6.dp),
            verticalAlignment: Alignment.CenterVertically
        ) {
            Text(text: "\(index + 1)", style: MaterialTheme.typography.caption, textAlign: TextAlign.Start, modifier: Modifier.padding(6.dp))
            Text(text: "\(thing.string)", style: MaterialTheme.typography.body1, textAlign: TextAlign.Start)
            Text(text: "\(thing.number)", style: MaterialTheme.typography.body2, textAlign: TextAlign.End, modifier: Modifier.fillMaxWidth())
        }
    }

    // SKIP INSERT: @Composable
    func ListView() {
        LazyColumn {
            itemsIndexed(rows) { index, thing in
                let state = rememberDismissState()
                SwipeToDismiss(state: state, background: {

                }) {
                    RowView(index: index, thing: thing)
                }
            }
        }
    }

    // SKIP INSERT: @Composable
    func HomeView() {
        Scaffold(topBar: {
            TopAppBar(title: {
                Text(text: model.title, style: MaterialTheme.typography.h6)
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

    // SKIP INSERT: @Composable
    func SearchView() {
        WebView(AppTabs.searchPage)
    }

    // SKIP INSERT: @Composable
    func WeatherView() {
        let ctx: Context = LocalContext.current

        var weather = remember {
            mutableStateOf(
                WeatherCondition(location: Location.default)
            )
        }

        @MainActor func fetchLocation(ctx: Context) async throws {
            logger.info("getting location…")
            let (lat, lon) = try await fetchCurrentLocation(ctx)
            logger.info("location: \(lat) \(lon)")
            weather.value.location.latitude = lat
            weather.value.location.longitude = lon
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
                Text(text: "Weather", style: MaterialTheme.typography.h4, modifier: Modifier.fillMaxWidth())
            }

            // SKIP INSERT: @Composable
            func latLonField(lat: Bool) {
                TextField(
                    value: lat ? weather.value.location.latitude.description : weather.value.location.longitude.description,
                    onValueChange: { newValue in
                        logger.log("setting \(lat ? "latitude" : "longitude") to: \(newValue)")
                        if lat {
                            weather.value.location.latitude = Double(newValue) ?? 0.0
                        } else {
                            weather.value.location.longitude = Double(newValue) ?? 0.0
                        }
                    },
                    label: {
                        Text(lat ? "Latitude" : "Longitude")
                    },
                    keyboardOptions: KeyboardOptions(keyboardType: KeyboardType.Number)
                )
            }

            Row {
                latLonField(lat: true)
            }

            Row {
                latLonField(lat: false)
            }

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
                }) {
                    Text("Current Location")
                }
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
                }) {
                    Text("Fetch Weather")
                }
            }

            if let temp = weather.value.temperature {
                Row {
                    Text(text: "Temperature", style: MaterialTheme.typography.h5, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())
                }

                Row {
                    Text(text: "\((temp * 9.0 / 5.0) + 32.0)°F", style: MaterialTheme.typography.h6, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())

                }
                Row {
                    Text(text: "\(temp)°C", style: MaterialTheme.typography.h6, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())
                }
            }
        }
    }

    // SKIP INSERT: @Composable
    func DeviceView() {
        WeatherView()
    }

    // SKIP INSERT: @Composable
    func FavoritesView() {
        FavoritesLabelView().eval()
    }

    // SKIP INSERT: @Composable
    func SettingsView() {
        Box(modifier: Modifier.fillMaxSize().padding(16.dp), contentAlignment: androidx.compose.ui.Alignment.Companion.Center) {
            Column {
                let context = androidx.compose.ui.platform.LocalContext.current
                let applicationId = context.packageName
                let packageInfo = context.packageManager.getPackageInfo(applicationId, 0)
                let appName = context.packageManager.getApplicationLabel(packageInfo.applicationInfo).toString()
                let versionName = packageInfo.versionName
                let versionCode = packageInfo.versionCode

                // SKIP INSERT: @Composable
                func row(_ text: String, style: TextStyle) {
                    Row(verticalAlignment: Alignment.CenterVertically, horizontalArrangement: Arrangement.End) {
                        Text(text: text, style: style, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())
                    }
                }

                row("Name: \(appName)", style: MaterialTheme.typography.h6)
                row("ID: \(applicationId)", style: MaterialTheme.typography.h6)
                row("Version: \(versionName) \(BuildConfig.DEBUG ? "(debug)" : "(release)")", style: MaterialTheme.typography.h6)
                row("Build: \(versionCode)", style: MaterialTheme.typography.h6)
            }
        }
    }

    // SKIP INSERT: @Composable
    func SelectedTabView(for tab: AppTabs) {
        switch tab {
        case .home: HomeView()
        case .device: DeviceView()
        case .favorites: FavoritesView()
        case .search: SearchView()
        case .settings: SettingsView()
        }
    }

    // SKIP INSERT: @Composable
    func AppTabView() {
        Box(modifier: Modifier.fillMaxSize().wrapContentSize(Alignment.Center)) {
            SelectedTabView(for: selectedTab.value)
        }
    }

    let colors = isSystemInDarkTheme()
        ? darkColors() // primary: primary, primaryVariant: primaryVariant, secondary: secondary, background: background)
        : lightColors() // primary: primary, primaryVariant: primaryVariant, secondary: secondary, background: background)

    MaterialTheme(colors: colors) {
        Scaffold(bottomBar: {
            BottomNavigation(modifier: Modifier.fillMaxWidth()) {
                // Create a tab bar with each of the possible tabs
                AppTabs.allCases.forEachIndexed { index, tab in
                    BottomNavigationItem(icon: { Icon(imageVector: tab.icon, contentDescription: tab.title) },
                                         label: { Text(tab.title) },
                                         //selectedContentColor: tabColorOn,
                                         //unselectedContentColor: tabColorOff,
                                         selected: tab == selectedTab.value,
                                         onClick: { selectedTab.value = tab }
                    )
                }
            }
        }) { contentPadding in
            let modifier = Modifier.padding(contentPadding)
            AppTabView()
        }
    }
}
#endif
