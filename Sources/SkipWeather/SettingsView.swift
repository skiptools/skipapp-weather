import SwiftUI
import Foundation
import SkipWeatherModel
import SkipDevice
import SkipKit

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
            NavigationLink("Sensor Calibration", value: 0.0)
            NavigationLink("System Info", value: ProcessInfo.processInfo)
        }
        .navigationDestination(for: URL.self) { url in
            WebView(url: url)
                .navigationTitle(url.host ?? "")
        }
        .navigationDestination(for: Double.self) { view in
            SensorCalibrationView()
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


struct SensorCalibrationView : View {
    var body: some View {
        Form {
            Section("Location") {
                LocationView()
            }
            Section("Barometer") {
                BarometerView()
            }
            Section("Accelerometer") {
                AccelerometerView()
            }
            Section("Gyroscope") {
                GyroscopeView()
            }
            Section("Magnetometer") {
                MagnetometerView()
            }
        }
    }
}

struct LocationView : View {
    @State var event: LocationEvent?
    //@State var permissionManager = PermissionManager.permissionRequestor()

    var body: some View {
        VStack {
            if let event = event {
                Text("latitude: \(event.latitude)")
                Text("longitude: \(event.longitude)")
                Text("altitude: \(event.altitude)")
                Text("course: \(event.course)")
                Text("speed: \(event.speed)")
            }
        }
        .font(Font.body.monospaced())
        .task {
            if await PermissionManager.requestLocationPermission(precise: true, always: false).isAuthorized == false {
                logger.warning("permission refused for ACCESS_FINE_LOCATION")
                return
            }

            let provider = LocationProvider() // must retain reference
            //provider.updateInterval = 0.1
            do {
                // SkipKit provided PermissionManager, which creates a user-interface to request individual permissions
                for try await event in provider.monitor() {
                    self.event = event
                    // if cancelled { break }
                }
            } catch {
                logger.error("error updating location: \(error)")
            }
            provider.stop()
        }
    }
}

struct BarometerView : View {
    @State var event: BarometerEvent?

    var body: some View {
        VStack {
            if let event = event {
                Text("pressure: \(event.pressure)")
                Text("relativeAltitude: \(event.relativeAltitude)")
            }
        }
        .font(Font.body.monospaced())
        .task {
            let provider = BarometerProvider() // must retain reference
            provider.updateInterval = 0.1
            do {
                for try await event in provider.monitor() {
                    self.event = event
                    // if cancelled { break }
                }
            } catch {
                logger.error("error updating barometer: \(error)")
            }
            provider.stop()
        }
    }
}

func clamp(_ value: Double) -> Double {
    min(1.0, max(0.0, value))
}

struct AccelerometerView : View {
    @State var event: AccelerometerEvent?

    var body: some View {
        VStack {
            if let event = event {
                ProgressView("X", value: clamp((1.0 + event.x) / 2.0)).tint(Color.red)
                ProgressView("Y", value: clamp((1.0 + event.y) / 2.0)).tint(Color.blue)
                ProgressView("Z", value: clamp((1.0 + event.z) / 2.0)).tint(Color.green)
                HStack {
                    Text("x: \(event.x)")
                    Text("y: \(event.y)")
                    Text("z: \(event.z)")
                }
                .font(Font.caption.monospaced())
                .lineLimit(1)
            }
        }
        .task {
            let provider = AccelerometerProvider() // must retain reference
            provider.updateInterval = 0.1
            do {
                for try await event in provider.monitor() {
                    self.event = event
                    // if cancelled { break }
                }
            } catch {
                logger.error("error updating accelerometer: \(error)")
            }
            provider.stop()
        }
    }
}

struct GyroscopeView : View {
    @State var event: GyroscopeEvent?

    var body: some View {
        VStack {
            if let event = event {
                ProgressView("X", value: clamp((1.0 + event.x) / 2.0)).tint(Color.red)
                ProgressView("Y", value: clamp((1.0 + event.y) / 2.0)).tint(Color.blue)
                ProgressView("Z", value: clamp((1.0 + event.z) / 2.0)).tint(Color.green)
                HStack {
                    Text("x: \(event.x)")
                    Text("y: \(event.y)")
                    Text("z: \(event.z)")
                }
                .font(Font.caption.monospaced())
                .lineLimit(1)
            }
        }
        .font(Font.body.monospaced())
        .task {
            let provider = GyroscopeProvider() // must retain reference
            provider.updateInterval = 0.1
            do {
                for try await event in provider.monitor() {
                    self.event = event
                    // if cancelled { break }
                }
            } catch {
                logger.error("error updating gyroscope: \(error)")
            }
            provider.stop()
        }
    }
}

struct MagnetometerView : View {
    @State var event: MagnetometerEvent?

    var body: some View {
        VStack {
            if let event = event {
                ProgressView("X", value: clamp((100.0 + event.x) / 200.0)).tint(Color.red)
                ProgressView("Y", value: clamp((100.0 + event.y) / 200.0)).tint(Color.blue)
                ProgressView("Z", value: clamp((100.0 + event.z) / 200.0)).tint(Color.green)
                HStack {
                    Text("x: \(event.x)")
                    Text("y: \(event.y)")
                    Text("z: \(event.z)")
                }
                .font(Font.caption.monospaced())
                .lineLimit(1)
            }
        }
        .font(Font.body.monospaced())
        .task {
            let provider = MagnetometerProvider() // must retain reference
            provider.updateInterval = 0.1
            do {
                for try await event in provider.monitor() {
                    self.event = event
                    // if cancelled { break }
                }
            } catch {
                logger.error("error updating magnetometer: \(error)")
            }
            provider.stop()
        }
    }
}
