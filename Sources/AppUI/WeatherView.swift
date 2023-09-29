import SwiftUI
import WeatherAppModel

struct WeatherNavigationView: View {
    static let title = "Weather"

    var body: some View {
        NavigationStack {
            WeatherView(showLocationButton: true)
                .navigationTitle(Self.title)
        }
    }
}

struct WeatherView : View {
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var error: String = ""
    @State var temperature: Double = Double.nan
    @AppStorage("celsius") var celsius: Bool = true
    let showLocationButton: Bool

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

            HStack {
                Text("Temperature:")
                if !error.isEmpty {
                    Text("\(error)")
                        .font(.headline)
                        .foregroundStyle(Color.red)
                } else {
                    if !temperature.isNaN {
                        Text(temperature.temperatureString(celsius: celsius))
                            .font(.headline)
                            .foregroundStyle(temperature.temperatureColor)
                    }
                }
            }
            Spacer()
        }
        #if !SKIP
        .textFieldStyle(.roundedBorder)
        #endif
        .padding()
        .task {
            // update immediately if we were constructed with a location
            if !latitude.isEmpty && !longitude.isEmpty {
                await updateWeather()
            }
        }
    }

    func updateWeather() async {
        do {
            self.error = "" // clear the current error
            let condition = try await fetchWeather()
            if let temperature = await condition.temperature {
                self.temperature = temperature
            }
        } catch {
            // set the error message label on failure
            self.error = "\(error)"
        }
    }

    func fetchWeather() async throws -> WeatherCondition {
        guard let lat = Double(self.latitude), let lon = Double(self.longitude) else {
            throw AppError(description: "Unable to parse coordinates")
        }
        logger.log("fetching weather for lat=\(lat) lon=\(lon)…")
        let location = Location(latitude: lat, longitude: lon)
        let condition = await WeatherCondition(location: location)
        let result = try await condition.fetchWeather()
        logger.log("fetched weather: \(result)")
        return condition
    }

    func updateCurrentLocation() async {
        logger.log("location button tapped")

    }
}
