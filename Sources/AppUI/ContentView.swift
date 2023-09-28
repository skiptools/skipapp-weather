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
            SettingsNavigationView()
                .tabItem {
                    Label(SettingsNavigationView.title, systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
