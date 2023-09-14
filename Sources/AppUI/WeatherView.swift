import SwiftUI
import AppModel

struct WeatherView : View {
    @State var latitude: String = ""
    @State var longitude: String = ""
    @State var error: String = ""
    @State var temperature: Double = Double.nan

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
                if !temperature.isNaN {
                    Text("Temperature: \(Int(temperature))°")
                        .font(.largeTitle)
                        .foregroundStyle(temperature < 15.0 ? Color.blue : temperature > 30.0 ? Color.red : Color.green)
                }
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
        if let temperature = await condition.temperature {
            self.temperature = temperature
        }
        logger.log("fetched weather: \(result)")
    }
}

struct AppError : LocalizedError {
    var description: String
}
