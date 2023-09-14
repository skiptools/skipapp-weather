import SwiftUI

struct SettingsView : View {
    @State var celsius: Bool = false

    var body: some View {
        VStack {
            Text("Settings").font(.largeTitle)
            Divider()
            Toggle("Celsius", isOn: $celsius)
            Spacer()
        }
        .font(.title2)
        .padding()
    }
}
