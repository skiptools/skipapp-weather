import SwiftUI
import Foundation
import WeatherAppModel

struct SettingsNavigationView: View {
    static let title = "Settings"

    var body: some View {
        NavigationStack {
            SettingsView()
                .navigationTitle(Self.title)
        }
    }
}

struct SettingsView : View {
    @AppStorage("celsius", store: UserDefaults.standard) var celsius: Bool = true

    var body: some View {
        List {
            HStack {
                Text("Fahrenheit/Celsius Units")
                Spacer()
                Text("\(Double(20.2).temperatureString(celsius: celsius))")
                    .font(.caption)
                Toggle("Fahrenheit/Celsius Units", isOn: $celsius).labelsHidden()
            }
            NavigationLink("About Skip", value: "skip.tools")
        }
        .navigationDestination(for: String.self) { host in
            WebView(url: URL(string: "https://\(host)")!)
                .navigationTitle(host)
        }
    }
}

#Preview {
    SettingsView()
}
