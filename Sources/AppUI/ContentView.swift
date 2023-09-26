import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ListNavigationView()
                .tabItem {
                    Label(ListNavigationView.title, systemImage: "house")
                }
            WeatherNavigationView()
                .tabItem {
                    Label(WeatherNavigationView.title, systemImage: "star")
                }
            searchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            SettingsNavigationView()
                .tabItem {
                    Label(SettingsNavigationView.title, systemImage: "gear")
                }
        }
    }

    func searchView() -> some View {
        WebView(url: URL(string: "https://skip.tools")!)
    }
}

#Preview {
    ContentView()
}
