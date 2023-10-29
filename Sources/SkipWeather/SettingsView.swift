import SwiftUI
import Foundation
import SkipWeatherModel

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
    @AppStorage("celsius") var celsius: Bool = true
    @AppStorage("kilometers") var kilometers: Bool = true

    var body: some View {
        List {
            HStack {
                Text("Fahrenheit/Celsius Units")
                Spacer()
                Text("\(Double(20.2).temperatureString(celsius: celsius))")
                    .font(.caption)
                Toggle("Fahrenheit/Celsius Units", isOn: $celsius).labelsHidden()
            }

            HStack {
                Text("Miles/Kilometers Units")
                Spacer()
                Text("\(Double(16.0).distanceString(kilometers: kilometers)) \(kilometers ? "km" : "mi")")
                    .font(.caption)
                Toggle("Miles/Kilometers Units", isOn: $kilometers).labelsHidden()
            }
            NavigationLink("About Skip", value: URL(string: "https://skip.tools")!)
            NavigationLink("System Info", value: ProcessInfo.processInfo)
        }
        .navigationDestination(for: URL.self) { url in
            WebView(url: url)
                .navigationTitle(url.host ?? "")
        }
        .navigationDestination(for: ProcessInfo.self) { info in
            let env = info.environment.keys.sorted()
                .map({ Env(key: $0, value: info.environment[$0]) })
            List(env, id: \.key) { keyValue in
                HStack(alignment: .top) {
                    Text(keyValue.key)
                        .font(.caption)
                    Spacer()
                    Text(keyValue.value ?? "")
                        .font(.footnote)
                }
            }
            .navigationTitle("System Info")
        }
    }

    /// An environment key/value
    private struct Env {
        let key: String
        let value: String?
    }
}


#Preview {
    SettingsView()
}
