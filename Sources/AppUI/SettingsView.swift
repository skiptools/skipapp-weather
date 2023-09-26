import SwiftUI
import Foundation

struct SettingsNavigationView: View {
    let title: LocalizedStringKey

    var body: some View {
        NavigationStack {
            SettingsView()
                .navigationTitle(Text(title, bundle: .module))
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
