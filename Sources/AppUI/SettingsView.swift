import SwiftUI
import Foundation

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
            Toggle("Celsius", isOn: $celsius)
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
