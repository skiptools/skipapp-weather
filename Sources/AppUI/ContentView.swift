import SwiftUI

#if !SKIP
/// The of the app: a tabbed view with tabs for each of the `AppTabs` enum.
struct ContentView: View {
    @State private var selectedTab = AppTabs.defaultTab

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTabs.allCases, id: \.self) { tab in
                selectedTabView(for: tab)
                    .tabItem {
                        Label {
                            Text(tab.title)
                        } icon: {
                            tab.icon()
                        }
                    }
                    .tag(tab)
            }
        }
        .onChange(of: selectedTab) { tab in
            logger.info("changed tab to: \(tab.rawValue)")
        }
    }

    @ViewBuilder func selectedTabView(for tab: AppTabs) -> some View {
        switch tab {
        case .home: ListView()
        case .content: WeatherView()
        case .search: searchView()
        case .settings: SettingsView()
        }
    }

    func searchView() -> some View {
        #if !os(iOS)
        // no UIViewRepresentable on macOS
        Spacer()
        #else
        return WebView(url: AppTabs.searchPage)
        #endif
    }

    func graphicsView() -> some View {
        GraphicsView(label: "SwiftUI")
    }
}

#else

import AndroidContent.Context
import AndroidxComposeRuntime
import AndroidxComposeMaterial3
import AndroidxComposeFoundation
import AndroidxComposeFoundationShape
import AndroidxComposeFoundationLayout
import AndroidxComposeFoundationText
import AndroidxComposeUi
import AndroidxComposeUiLayout
import AndroidxComposeUiPlatform
import AndroidxNavigation
import AndroidxNavigationCompose


@ExperimentalMaterial3Api
@Composable func ContentView() {
    @Composable func searchView() {
        WebView(AppTabs.searchPage)
    }

    @Composable func graphicsView(modifier: Modifier) {
        Box(modifier: Modifier.fillMaxSize().then(modifier), contentAlignment: androidx.compose.ui.Alignment.Center) {
            GraphicsView(label: "Compose").Compose()
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
                    NavigationBarItem(icon: { tab.icon() }, label: { androidx.compose.material3.Text(tab.title.value) }, selected: tab.rawValue == currentRoute(navController), onClick: {
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
                        case AppTabs.home: ListView().Compose()
                        case AppTabs.content: WeatherView().Compose()
                        case AppTabs.search: searchView()
                        case AppTabs.settings: SettingsView().Compose()
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
        )

        MaterialTheme(colorScheme: colorScheme, typography: typography) {
            NavigationScaffold()
        }
    }

    ThemedNavigationScaffold()

}
#endif

