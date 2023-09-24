import SwiftUI

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
            Toggle("Celsius", isOn: $celsius)
            Spacer()
        }
        .font(.title2)
        .padding()
    }
}
