#if !SKIP
import Foundation
import AppModel

import SwiftUI

/// Returns the Icon for this tab.
/// On iOS returns `SwiftUI.Image`
/// On Android returns `androidx.compose.ui.graphics.vector.ImageVector`
extension AppTabs {
    var icon: Image {
        switch self {
        case .home: return Image(systemName: "house")
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
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }

    func searchView() -> some View {
        Text(AppTabs.search.title)
    }

    func settingsView() -> some View {
        Text(AppTabs.settings.title)
    }
}

#endif
