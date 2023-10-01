import Foundation
import SwiftUI
import WeatherAppModel

struct WeatherNavigationView: View {
    static let title = "Weather"

    var body: some View {
        NavigationStack {
            WeatherView()
                .navigationTitle(Self.title)
        }
    }
}

struct WeatherView : View {
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var error: String = ""
    @StateObject var weather = WeatherCondition()
    @AppStorage("celsius") var celsius: Bool = true
    var showLocationButton = false

    init(location: Location? = nil) {
        if let location {
            _latitude = State(initialValue: String(describing: location.latitude))
            _longitude = State(initialValue: String(describing: location.longitude))
        } else {
            showLocationButton = true
        }
    }

    var body: some View {
        VStack {
            HStack {
                VStack {
                    HStack {
                        Text("Lat:")
                        TextField("Latitude", text: $latitude)
                    }
                    HStack {
                        Text("Lon:")
                        TextField("Longitude", text: $longitude)
                    }
                }
                if showLocationButton {
                    Button {
                        Task {
                            await updateCurrentLocation()
                        }
                    } label: {
                        Image(systemName: "location")
                    }
                }
            }

            Button("Fetch Weather") {
                Task {
                    await updateWeather()
                }
            }
            .buttonStyle(.borderedProminent)

            Divider()

            if !error.isEmpty {
                Text("\(error)")
                    .font(.headline)
                    .foregroundStyle(Color.red)
            } else {
                if let temperature = weather.temperature {
                    Text(temperature.temperatureString(celsius: celsius))
                        .font(.largeTitle).bold()
                        .foregroundStyle(temperature.temperatureColor)
                }
            }
            Spacer()
        }
        #if !SKIP
        .textFieldStyle(.roundedBorder)
        #endif
        .padding()
        .task {
            if !latitude.isEmpty && !longitude.isEmpty {
                await updateWeather()
            }
        }
    }

    func updateWeather() async {
        guard let lat = Double(self.latitude), let lon = Double(self.longitude) else {
            self.error = "Unable to parse coordinates"
            return
        }

        self.error = "" // clear the current error
        do {
            logger.log("fetching weather for lat=\(lat) lon=\(lon)…")
            let location = Location(latitude: lat, longitude: lon)
            let result = try await weather.fetchWeather(at: location)
            logger.log("fetched weather: \(result)")
        } catch {
            // set the error message label on failure
            self.error = "\(error)"
        }
    }

    func updateCurrentLocation() async {
        self.error = "" // clear the current error
        do {
            let location = try await fetchLocation()
            latitude = String(describing: location.latitude)
            longitude = String(describing: location.longitude)
        } catch {
            // set the error message label on failure
            self.error = "\(error)"
        }
    }

    func fetchLocation() async throws -> Location {
        #if SKIP
        let context = ProcessInfo.processInfo.androidContext
        let (latitude, longitude) = fetchCurrentLocation(context) // Defined in CustomKotlin.kt
        #else
        let (latitude, longitude) = try await LocationProvider.shared.fetchCurrentLocation()
        #endif
        return Location(latitude: latitude, longitude: longitude)
    }
}

extension Double {
    /// Takes the current temperature (in celsius) and creates string description.
    func temperatureString(celsius: Bool, withUnit: Bool = true) -> String {
        // perform conversion if needed
        let temp = celsius ? self : ((self * 9/5) + 32)
        // Celsius temperatures are generally formatted with 1 decimal place, whereas Fahrenheit is not
        let fmt = String(format: "%.\(celsius ? 1 : 0)f", temp)
        return withUnit ? "\(fmt) °\(celsius ? "C" : "F")" : "\(fmt)°"
    }

    /// Interpolates an RGB 3-tuple based on a parameter expressing the fraction between the colors blue and red.
    var temperatureColor: Color {
        let p = (self * 3.0) / 100.0 // 0.0 is 0% and 50.0 is 100%
        let rgb = interpolateRGB(fromColor: (r: 0.0, g: 0.0, b: 1.0), toColor: (r: 1.0, g: 0.0, b: 0.0), fraction: p)
        return Color(red: rgb.r, green: rgb.g, blue: rgb.b)
    }
}

func interpolateRGB(fromColor: (r: CGFloat, g: CGFloat, b: CGFloat), toColor: (r: CGFloat, g: CGFloat, b: CGFloat), fraction: CGFloat) -> (r: CGFloat, g: CGFloat, b: CGFloat) {
    let clampedFraction = max(0.0, min(1.0, fraction))

    let ir = fromColor.r + (toColor.r - fromColor.r) * clampedFraction
    let ig = fromColor.g + (toColor.g - fromColor.g) * clampedFraction
    let ib = fromColor.b + (toColor.b - fromColor.b) * clampedFraction

    return (ir, ig, ib)
}

#if !SKIP
import CoreLocation

class LocationProvider: NSObject {
    static let shared = LocationProvider()

    private let locationManager = CLLocationManager()
    private var completions: [(Result<(Double, Double), Error>) -> Void] = []

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func fetchCurrentLocation() async throws -> (latitude: Double, longitude: Double) {
        return try await withCheckedThrowingContinuation { continuation in
            requestLocation { result in
                switch result {
                case .success(let location):
                    continuation.resume(returning: location)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func requestLocation(completion: @escaping (Result<(Double, Double), Error>) -> Void) {
        completions.append(completion)
        requestLocationOrAuthorization()
    }

    private func requestLocationOrAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestLocation()
        }
    }
}

extension LocationProvider: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if !completions.isEmpty {
            requestLocationOrAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let completions = self.completions
        self.completions = []
        let location = locations.last!
        completions.forEach { $0(.success((location.coordinate.latitude, location.coordinate.longitude))) }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let completions = self.completions
        self.completions = []
        completions.forEach { $0(.failure(error)) }
    }
}
#endif
