import SwiftUI

#if !SKIP
/// The content of the app: a tabbed view with tabs for each of the `AppTabs` enum.
struct ContentView: View {
    @State private var selectedTab = AppTabs.defaultTab

    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTabs.allCases, id: \.self) { tab in
                selectedTabView(for: tab)
                    .tabItem {
                        Label {
                            Text(tab.title, bundle: .module)
                        } icon: {
                            tab.icon
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
        case .home: ListNavigationView(title: tab.title)
        case .content: WeatherNavigationView(title: tab.title)
        case .search: searchView()
        case .settings: SettingsNavigationView(title: tab.title)
        }
    }

    func searchView() -> some View {
        WebView(url: AppTabs.searchPage)
    }
}

#Preview {
    ContentView()
}

#else
import android.content.Context
import androidx.compose.runtime.__
import androidx.compose.material3.__
import androidx.compose.foundation.__
import androidx.compose.foundation.layout.__
import androidx.compose.foundation.shape.__
import androidx.compose.foundation.text.__
import androidx.compose.ui.__
import androidx.compose.ui.layout.__
import androidx.compose.ui.platform.__
import androidx.navigation.__
import androidx.navigation.compose.__

@ExperimentalMaterial3Api
@Composable func ContentView() {
    @Composable func searchView(modifier: Modifier) {
        WebView(AppTabs.searchPage, modifier: modifier)
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
                    NavigationBarItem(icon: { tab.icon.Compose() }, label: { androidx.compose.material3.Text(tab.title.value) }, selected: tab.rawValue == currentRoute(navController), onClick: {
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
            let context = ComposeContext(modifier: Modifier.padding(contentPadding))
            NavHost(navController, startDestination: AppTabs.defaultTab.rawValue) {
                AppTabs.allCases.forEachIndexed { index, tab in
                    composable(tab.rawValue) {
                        switch tab {
                        case AppTabs.home: ListNavigationView(title: tab.title).Compose(context: context)
                        case AppTabs.content: WeatherNavigationView(title: tab.title).Compose(context: context)
                        case AppTabs.search: searchView(modifier: context.modifier)
                        case AppTabs.settings: SettingsNavigationView(title: tab.title).Compose(context: context)
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

        var typography = Typography()

        MaterialTheme(colorScheme: colorScheme, typography: typography) {
            NavigationScaffold()
        }
    }

    ThemedNavigationScaffold()
}
#endif

