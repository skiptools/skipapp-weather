#if SKIP
import Foundation
import AppModel

import AndroidApp
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
import AndroidxComposeUi
import AndroidxComposeUiGeometry
import AndroidxComposeUiGraphics
import AndroidxComposeUiGraphicsVector
import AndroidxComposeUiLayout
import AndroidxComposeUiText
import AndroidxComposeUiTextFont
import AndroidxComposeUiTextStyle
import AndroidxComposeUiToolingPreview
import AndroidxComposeUiUnit
// SKIP INSERT: import kotlinx.coroutines.launch
// SKIP INSERT: import kotlinx.coroutines.withContext
// SKIP INSERT: import kotlinx.coroutines.Dispatchers

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
    func DeviceView() {
        Row(verticalAlignment: Alignment.CenterVertically, horizontalArrangement: Arrangement.End) {
            Text(text: AppTabs.device.title, style: MaterialTheme.typography.subtitle1, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())
        }
    }

    // SKIP INSERT: @Composable
    func FavoritesView() {
        let scope = rememberCoroutineScope()
        var bytesDownloaded = remember { mutableStateOf(0) }

        Row(verticalAlignment: Alignment.CenterVertically, horizontalArrangement: Arrangement.End) {
            //Text(text: AppTabs.favorites.title, style: MaterialTheme.typography.subtitle1, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())
            Column {
                Button(onClick: {
                    //let contents = java.net.URL("https://skip.tools").readText() // android.os.NetworkOnMainThreadException

                    logger.log("button click")
                    scope.launch {
                        logger.log("in scope")

                        withContext(Dispatchers.IO) {
                            logger.log("dispatching HTTP request")

                            //logger.log("contents: \(contents.length)")
                            // TODO: fix default timeout
                            // java.net.SocketTimeoutException: failed to connect to skip.tools/75.119.205.21 (port 443) from /10.0.2.16 (port 59564) after 60ms
                            //let (data, response) = try await URLSession.shared.data(for: URLRequest(url: AppTabs.searchPage))
                            //logger.log("response: \(response) data: \(data.count)")
                            //bytesDownloaded.value = data.count

                            let contents = java.net.URL(AppTabs.searchPage.absoluteString).readText()
                            bytesDownloaded.value = contents.length
                        }
                    }
                }) {
                    Text("Fetch")
                }
            }

            Column {
                Text("Data: \(bytesDownloaded.value)")
            }
        }
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
        SelectedTabView(for: selectedTab.value)
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
