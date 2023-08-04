#if !SKIP
import Foundation
import AppModel
import SkipUI

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
        case .favorites: return Image(systemName: "star")
        case .search: return Image(systemName: "magnifyingglass")
        case .settings: return Image(systemName: "gear")
        }
    }
}

class Model : ObservableObject {
    @Published var title = "Ahoy, Skipper!"
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

    func addRow() {
        logger.info("Tapped add button")
        model.things.append(Stuff.allThings[min(Stuff.allThings.count - 1, model.things.count)])
    }

    func rowView(index: Int, thing: Thing) -> some View {
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
        .onChange(of: selectedTab) { tab in
            logger.info("changed tab to: \(tab.title)")
        }
    }

    @ViewBuilder func selectedTabView(for tab: AppTabs) -> some View {
        switch tab {
        case .home: listView()
        case .device: deviceView()
        case .favorites: favoritesView()
        case .search: searchView()
        case .settings: settingsView()
        }
    }

    func listView() -> some View {
        NavigationStack {
            List {
                ForEach(Array(model.things.enumerated()), id: \.offset) { index, thing in
                    rowView(index: index, thing: thing)
                }
            }
            .navigationTitle(Text(model.title))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: { withAnimation { addRow() } }) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
    }

    func deviceView() -> some View {
        Text(AppTabs.device.title)
    }

    func favoritesView() -> some SkipView {
        FavoritesLabelView()
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
        return AppMetadataView()
    }
}

#endif
