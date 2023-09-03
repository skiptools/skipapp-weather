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

/// Returns the Icon for this tab.
/// On iOS returns `SwiftUI.Image`
/// On Android returns `androidx.compose.ui.graphics.vector.ImageVector`
extension AppTabs {
    var icon: Image {
        switch self {
        case .home: return Image(systemName: "house")
        case .device: return Image(systemName: "list.bullet")
        //case .favorites: return Image(systemName: "star")
        case .search: return Image(systemName: "magnifyingglass")
        case .settings: return Image(systemName: "gear")
        }
    }
}

class Model : ObservableObject {
    @Published var things: [Thing] = Stuff().things

    init() {
    }
}

public struct ContentView: View {
    @ObservedObject var model = Model()
    @State private var selectedTab = AppTabs.defaultTab

    public init() {
    }

    public var body: some View {
        appTabView()
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
        .onChange(of: selectedTab) { tab in
            logger.info("changed tab to: \(tab.title)")
        }
    }

    @ViewBuilder func selectedTabView(for tab: AppTabs) -> some View {
        switch tab {
        case .home: CitiesListView()
        case .device: deviceView()
        //case .favorites: favoritesView()
        case .search: searchView()
        case .settings: settingsView()
        }
    }

    func deviceView() -> some View {
        Text(AppTabs.device.title)
    }

    func favoritesView() -> some View {
        SkipSampleView(label: "SwiftUI")
    }

    func searchView() -> some View {
        #if !os(iOS)
        // no UIViewRepresentable on macOS
        Spacer()
        #else
        return WebView(url: AppTabs.searchPage)
        #endif
    }

    func settingsView() -> some View {
        struct AppMetadataView: View {
            // Get the app's information from the main bundle
            let appDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
            let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
            let appBuildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""
            let appBundleIdentifier = Bundle.main.bundleIdentifier ?? ""

            var body: some View {
                VStack(alignment: .leading, spacing: 16) {
                    Text("App Name: \(appDisplayName)")
                    Text("Version: \(appVersion)")
                    Text("Build Number: \(appBuildNumber)")
                    Text("Bundle Identifier: \(appBundleIdentifier)")
                }
                .padding()
            }
        }

        struct StateToggleContainer: View {
            @State var counterToggle = false

            var body: some View {
                HStack {
                    Button("Toggle", action: { counterToggle = !counterToggle })
                    if counterToggle {
                        StateToggleView().id(true)
                    } else {
                        StateToggleView().id(false)
                    }
                }
            }
        }

        struct StateToggleView: View {
            @State var countState = 0
            var body: some View {
                Button("Counter: \(countState)", action: { countState += 1 })

            }
        }

        return AppMetadataView()
//        return StateToggleContainer()
    }
}

#endif
