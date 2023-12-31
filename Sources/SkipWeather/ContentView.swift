import SwiftUI

public struct ContentView: View {
    public init() {
    }
    
    public var body: some View {
        TabView {
            ListNavigationView()
                .tabItem {
                    Label(ListNavigationView.title, systemImage: "house.fill")
                }
            WeatherNavigationView()
                .tabItem {
                    Label(WeatherNavigationView.title, systemImage: "star")
                }
            SettingsNavigationView()
                .tabItem {
                    Label(SettingsNavigationView.title, systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
