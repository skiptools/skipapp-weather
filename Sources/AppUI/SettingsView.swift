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
        VStack {
            Toggle("Fahrenheit/Celsius Units", isOn: $celsius)
            HStack {
                Spacer()
                Text("\(Double(20.2).temperatureString(celsius: celsius))")
                    .font(.caption)
            }
            Divider()
            Spacer()
        }
        .font(.title2)
        .padding()
    }
}

#Preview {
    SettingsView()
}
