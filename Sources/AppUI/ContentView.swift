import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            VStack {
                Text("SKIP").font(.largeTitle).bold()
                    .foregroundStyle(androidSDK != nil ? Color.green : Color.blue)
            }
            .tabItem {
                Label("Skip", systemImage: "info")
            }
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
