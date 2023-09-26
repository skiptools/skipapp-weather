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
    @State var celsius: Bool = false

    var body: some View {
        VStack {
            Toggle(isOn: $celsius) {
                Text(LocalizedStringKey("Celsius"), bundle: .module)
            }
            Divider()
            Spacer()
        }
        .font(.title2)
        .padding()
    }
}

#if !SKIP
#Preview {
    SettingsView()
}
#endif
