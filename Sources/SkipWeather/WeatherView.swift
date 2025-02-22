import Foundation
import SwiftUI
import SkipWeatherModel
import SkipDevice

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
    @StateObject var currentLocation = CurrentLocation()
    @AppStorage("celsius") var celsius: Bool = true
    @AppStorage("kilometers") var kilometers: Bool = true
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
                            .frame(width: 50.0)
                        TextField("Latitude", text: $latitude)
                    }
                    HStack {
                        Text("Lon:")
                            .frame(width: 50.0)
                        TextField("Longitude", text: $longitude)
                    }
                }

                if showLocationButton {
                    ZStack {
                        Button {
                            Task {
                                await updateCurrentLocation()
                            }
                        } label: {
                            Image(systemName: "location")
                        }
                        .opacity(currentLocation.isFetching ? 0.0 : 1.0)

                        ProgressView()
                            .opacity(currentLocation.isFetching ? 1.0 : 0.0)
                    }
                    .padding(.all, 4.0)
                }
            }

            if let title = currentLocationTitle() {
                Text(title).font(.headline)
            }

            Button("Fetch Weather") {
                Task {
                    await updateWeather()
                }
            }
            .buttonStyle(.borderedProminent)

            if !error.isEmpty {
                Text("\(error)")
                    .font(.headline)
                    .foregroundStyle(Color.red)
            } else {
                if weather.isFetching {
                    ProgressView()
                } else if let temperature = weather.temperature {
                    Text(temperature.temperatureString(celsius: celsius))
                        .font(.largeTitle).bold()
                        .foregroundStyle(temperature.temperatureColor)
                }
            }
            Spacer()
        }
        .textFieldStyle(.roundedBorder)
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
            let location = Location(latitude: lat, longitude: lon)
            try await weather.fetch(at: location)
        } catch {
            self.error = "\(error)"
        }
    }

    func updateCurrentLocation() async {
        self.error = "" // clear the current error
        do {
            try await currentLocation.fetch()
        } catch {
            self.error = "\(error)"
        }
        if let location = currentLocation.location {
            latitude = String(describing: location.latitude)
            longitude = String(describing: location.longitude)
            await updateWeather()
        }
    }

    /// The name of the current location, in terms of the distance and heading from the nearest city
    func currentLocationTitle() -> String? {
        guard let location = currentLocation.location else {
            // only display the title if we have a current location
            return nil
        }

        let city = location.nearestCity
        let distance = city.location.distance(from: location)
        if distance < 2.0 {
            return city.cityName
        } else {
            return distance.distanceString(kilometers: kilometers) + " " + (kilometers ? "kilometers" : "miles") + " from " + city.cityName
        }
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

    /// Takes the current distance (in kilometers) and creates a string description of miles vs. kilometers
    func distanceString(kilometers: Bool) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        let numstr = fmt.string(from: Int(kilometers ? (self) : (self / 1.60934)) as NSNumber)!
        return numstr + (kilometers ? " km" : " mi")
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
