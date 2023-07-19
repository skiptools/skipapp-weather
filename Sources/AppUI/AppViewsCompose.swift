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
    case .search: return Icons.Default.Search
    case .settings: return Icons.Default.Settings
    }
}

// SKIP INSERT: @Preview(name = "Light theme")
// SKIP INSERT: @Preview(name = "Dark theme")
// SKIP INSERT: @Composable
func ContentView() -> Void {
    let model = Stuff()
    let rows = remember { Stuff().things.toList().toMutableStateList() }
    var selectedTab = remember { mutableStateOf(AppTabs.allCases[0]) }

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
                RowView(index: index, thing: thing)
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
                    Icon(imageVector: Icons.Default.Add, contentDescription: "Add")
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
    func SettingsView() {
        Row(verticalAlignment: Alignment.CenterVertically, horizontalArrangement: Arrangement.End) {
            Text(text: AppTabs.settings.title, style: MaterialTheme.typography.subtitle1, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth())
        }
    }


    // SKIP INSERT: @Composable
    func SelectedTabView(for tab: AppTabs) {
        switch tab {
        case .home: HomeView()
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
