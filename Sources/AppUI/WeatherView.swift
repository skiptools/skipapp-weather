import SwiftUI
import AppModel

struct WeatherView : View {
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var error: String = ""

    var body: some View {
        VStack {
            Text("Weather")
                .font(.largeTitle)
            HStack {
                Text("Lat:")
                TextField(text: $latitude) {
                    Text("Latitude")
                }
            }
            HStack {
                Text("Lon:")
                TextField(text: $longitude) {
                    Text("Longitude")
                }
            }

            Button("Fetch Weather") {
                Task {
                    do {
                        self.error = "" // clear the current error
                        try await updateWeather()
                    } catch {
                        // set the error message label on failure
                        self.error = "\(error)"
                    }
                }
            }
            .buttonStyle(.borderedProminent)

            if !error.isEmpty {
                Text("\(error)")
                    .font(.headline)
                    .foregroundStyle(Color.red)
            } else {
                // if let temp = weather.value.temperature {
                //    Row { androidx.compose.material3.Text(text: "Temperature", style: MaterialTheme.typography.headlineMedium, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth()) }
                //    Row { androidx.compose.material3.Text(text: "\((temp * 9.0 / 5.0) + 32.0)°F", style: MaterialTheme.typography.headlineSmall, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth()) }
                // Row { androidx.compose.material3.Text(text: "\(temp)°C", style: MaterialTheme.typography.headlineSmall, textAlign: TextAlign.Center, modifier: Modifier.fillMaxWidth()) }
                // }

            }
            Spacer()
        }
        #if !SKIP
        .textFieldStyle(.roundedBorder)
        #endif
        .padding()
    }

    func updateWeather() async throws {
        guard let lat = Double(self.latitude), let lon = Double(self.longitude) else {
            throw AppError(description: "Unable to parse coordinates")
        }
        logger.log("fetching weather for lat=\(lat) lon=\(lon)…")
        let location = Location(latitude: lat, longitude: lon)
        let condition = await WeatherCondition(location: location)
        let result = try await condition.fetchWeather()
        logger.log("fetched weather: \(result)")
    }
}

struct AppError : LocalizedError {
    var description: String
}
