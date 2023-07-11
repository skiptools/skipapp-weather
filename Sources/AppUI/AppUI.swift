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
            return Image(systemName: "home")
            #endif
        case .search:
            #if SKIP
            return Icons.Default.Search
            #else
            return Image(systemName: "search")
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

    public init() {
    }

    public var body: some View {
        NavigationView {
            List {
                ForEach(Array(model.things.enumerated()), id: \.offset) { index, thing in
                    makeRow(index: index, thing: thing)
                }
            }
            .navigationTitle(Text(model.title))
            .toolbar {
                ToolbarItem(placement: .navigation) {
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

    func addRow() {
        logger.info("Tapped add button")
        model.things.append(Thing(string: "Just one more thing…", number: 1.0))
    }

    func makeRow(index: Int, thing: Thing) -> some View {
        HStack {
            Text("\(index)").font(.caption)
            Text("\(thing.string)").font(.body)
            Text("\(thing.number)").font(.callout)
        }
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
            rows.add(Thing(string: "Just one more thing…", number: 1.0))
        }

        Scaffold(topBar: {
            TopAppBar(title: {
                Text(text: model.title, style: MaterialTheme.typography.h4)
            })
        },
        bottomBar: {
            BottomNavigation(modifier: Modifier.fillMaxWidth(), backgroundColor: MaterialTheme.colors.primary) {
                AppTabs.allCases.forEachIndexed { index, tab in
                    BottomNavigationItem(icon: {             Icon(imageVector: tab.icon, contentDescription: tab.title) },
                     label: { Text(tab.title) },
                     selected: index == selectedTabIndex.value,
                     onClick = { selectedTabIndex.value = index }
                    )
                }
            }
        },
        floatingActionButtonPosition: FabPosition.Center,
        floatingActionButton: {
            ExtendedFloatingActionButton(onClick: {
                addRow()
            }, text: {
                Text("Add Thing")
            }, icon: {
                Icon(imageVector: Icons.Default.Add, contentDescription: "Add")
            }, modifier: Modifier.navigationBarsPadding())
        }) { contentPadding in
            LazyColumn(modifier: Modifier.padding(16.dp)) {
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
            Text(text: "\(index)", style: MaterialTheme.typography.caption, textAlign: TextAlign.Start, modifier: Modifier.padding(6.dp))
            Text(text: "\(thing.string)", style: MaterialTheme.typography.body1, textAlign: TextAlign.Start)
            Text(text: "\(thing.number)", style: MaterialTheme.typography.body2, textAlign: TextAlign.End, modifier: Modifier.fillMaxWidth())
        }
    }
}

#endif
