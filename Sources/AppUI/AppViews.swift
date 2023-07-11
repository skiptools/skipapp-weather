import Foundation
import OSLog
import AppModel

#if !SKIP
import SwiftUI
#else
import AndroidApp
import AndroidxAppcompatApp
import AndroidxActivityCompose
import AndroidxComposeRuntime
import AndroidxComposeMaterial
import AndroidxComposeMaterialIcons
import AndroidxComposeMaterialIconsFilled
import AndroidxComposeUiGeometry
import AndroidxComposeUi
import AndroidxComposeUiUnit
import AndroidxComposeUiGraphics
import AndroidxComposeUiGraphicsVector
import AndroidxComposeUiLayout
import AndroidxComposeUiText
import AndroidxComposeUiTextStyle
import AndroidxComposeFoundation
import AndroidxComposeFoundationShape
import AndroidxComposeFoundationLayout
import AndroidxComposeFoundationLazy
import AndroidxComposeFoundationLazy.items
import AndroidxComposeFoundationLazy.itemsIndexed
#endif

let logger = Logger(subsystem: "app.ui", category: "AppUI")

/// The tabs for the app
enum AppTabs : String, CaseIterable {
    case home
    case search
    case settings

    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .settings: return "Settings"
        }
    }

    #if SKIP
    typealias IconType = ImageVector
    #else
    typealias IconType = SwiftUI.Image
    #endif

    /// Returns the Icon for this tab.
    /// On iOS returns `SwiftUI.Image`
    /// On Androd returns `androidx.compose.ui.graphics.vector.ImageVector`
    var icon: IconType {
        switch self {
        case .home:
            #if SKIP
            return Icons.Default.Home
            #else
            return Image(systemName: "house")
            #endif
        case .search:
            #if SKIP
            return Icons.Default.Search
            #else
            return Image(systemName: "magnifyingglass")
            #endif
        case .settings:
            #if SKIP
            return Icons.Default.Settings
            #else
            return Image(systemName: "gear")
            #endif
        }
    }

}

#if !SKIP

class Model : ObservableObject {
    @Published var title = "Ahoy, Skipper!"
    @Published var things: [Thing] = Stuff().things

    init() {
    }
}

public struct ContentView: View {
    @ObservedObject var model = Model()
    @State private var selectedTab = AppTabs.home

    public init() {
    }

    public var body: some View {
        appTabView()
    }

    func addRow() {
        logger.info("Tapped add button")
        model.things.append(Stuff.allThings[min(Stuff.allThings.count - 1, model.things.count)])
    }

    func makeRow(index: Int, thing: Thing) -> some View {
        HStack {
            Text("\(index + 1)").font(.caption)
            Text("\(thing.string)").font(.body)
            Spacer()
            Text("\(thing.number, format: .number)").font(.callout)
        }
    }

    func appTabView() -> some View {
        TabView(selection: $selectedTab) {
            ForEach(AppTabs.allCases, id: \.self) { tab in
                selectedTabView(for: tab)
                    .tabItem {
                        Label {
                            Text(tab.title)
                        } icon: {
                            tab.icon
                        }

                    }
                    .tag(tab)
            }
        }
    }

    @ViewBuilder func selectedTabView(for tab: AppTabs) -> some View {
        switch tab {
        case .home: listView()
        case .search: searchView()
        case .settings: settingsView()
        }
    }

    func listView() -> some View {
        NavigationView {
            List {
                ForEach(Array(model.things.enumerated()), id: \.offset) { index, thing in
                    makeRow(index: index, thing: thing)
                }
            }
            .navigationTitle(Text(model.title))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {
                        withAnimation {
                            addRow()
                        }
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    func searchView() -> some View {
        Text("Web View")
    }

    func settingsView() -> some View {
        Text("Form View")
    }
}

#else

/// AndroidAppMain is the `android.app.Application` entry point, and must match `application android:name` in the AndroidMainfest.xml file
public class AndroidAppMain : Application {
    public init() {
    }

    public override func onCreate() {
        super.onCreate()
        logger.info("starting app")
        logger.trace("external function: \(externalKotlinFunction())")
        
        // this sets the global `ProcessInfo.processInfo.launchContext` property, which is needed by SkipFoundation
        ProcessInfo.launch(applicationContext)
    }
}

/// AndroidAppMain is initial `androidx.appcompat.app.AppCompatActivity`, and must match `activity android:name` in the AndroidMainfest.xml file
public class MainActivity : AppCompatActivity {
    let model = Stuff()

    public init() {
    }

    public override func onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            ContentView()
        }
    }

    // SKIP INSERT: @Composable
    func ContentView() -> Void {
        let rows = remember { model.things.toList().toMutableStateList() }
        var selectedTabIndex = remember { mutableStateOf(0) }

        func addRow() {
            logger.info("Tapped add button")
            rows.add(Stuff.allThings[min(Stuff.allThings.count - 1, model.things.count)])
        }

        Scaffold(topBar: {
            TopAppBar(title: {
                Text(text: model.title, style: MaterialTheme.typography.h4)
            },
            actions: {
                IconButton(onClick: {
                    addRow()
                }) {
                    Icon(imageVector: Icons.Default.Add, contentDescription: "Add")
                }
            })
        },
        bottomBar: {
            BottomNavigation(modifier: Modifier.fillMaxWidth(), backgroundColor: MaterialTheme.colors.background, contentColor: MaterialTheme.colors.primary) {
                // Create a tab bar with each of the possible tabs
                AppTabs.allCases.forEachIndexed { index, tab in
                    BottomNavigationItem(icon: { Icon(imageVector: tab.icon, contentDescription: tab.title) },
                     label: { Text(tab.title) },
                     selected: index == selectedTabIndex.value,
                     onClick = { selectedTabIndex.value = index }
                    )
                }
            }
        }) { contentPadding in
            LazyColumn {
                itemsIndexed(rows) { index, thing in
                    makeRow(index: index, thing: thing)
                }
            }
        }
    }

    // SKIP INSERT: @Composable
    func makeRow(index: Int, thing: Thing) -> Void {
        Row(modifier: Modifier.padding(6.dp),
            verticalAlignment: Alignment.CenterVertically
        ) {
            Text(text: "\(index + 1)", style: MaterialTheme.typography.caption, textAlign: TextAlign.Start, modifier: Modifier.padding(6.dp))
            Text(text: "\(thing.string)", style: MaterialTheme.typography.body1, textAlign: TextAlign.Start)
            Text(text: "\(thing.number)", style: MaterialTheme.typography.body2, textAlign: TextAlign.End, modifier: Modifier.fillMaxWidth())
        }
    }
}

#endif
