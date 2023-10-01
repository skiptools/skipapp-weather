import Foundation
import Combine

/// A lat/lon location (in degrees).
public struct Location : Hashable, Codable {
    public var latitude: Double
    public var longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }

    func coordinates(fractionalDigits: Int? = nil) -> (latitude: Double, longitude: Double) {
        guard let fractionalDigits = fractionalDigits else {
            return (latitude, longitude)
        }
        let factor = pow(10.0, Double(fractionalDigits))
        return (latitude: Double(round(latitude * factor)) / factor, longitude: Double(round(longitude * factor)) / factor)
    }
}

public class WeatherCondition : ObservableObject {
    /// The User-Agent header when making requests
    static let userAgent = "Demo App"

    @Published public private(set) var location: Location?
    @Published public private(set) var temperature: Double?
    @Published public private(set) var isFetching = false

    public init() {
    }

    @MainActor
    @discardableResult public func fetchWeather(at location: Location) async throws -> Int {
        self.location = location
        temperature = nil
        isFetching = true

        let (lat, lon) = location.coordinates(fractionalDigits: 4)
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true")!
        logger.info("fetching URL: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.setValue(Self.userAgent, forHTTPHeaderField: "User-Agent")
        let (data, response) = try await URLSession.shared.data(for: request)
        // guard against updating for a concurrent request
        if location == self.location {
            let decoder = JSONDecoder()
            let info = try decoder.decode(WeatherResponse.self, from: data)
            temperature = info.current_weather.temperature
            isFetching = false
        }
        return (response as? HTTPURLResponse)?.statusCode ?? 0
    }
}

/// A JSON response from the open-meteo.com weather service
struct WeatherResponse : Hashable, Codable {
    var latitude: Double // e.g.: 42.36515
    var longitude: Double // e.g.: -71.0618
    var generationtime_ms: Double // e.g.: 0.6880760192871094
    var utc_offset_seconds: Double // e.g.: 0
    var timezone: String // e.g.: "GMT"
    var timezone_abbreviation: String // e.g.: "GMT"
    var elevation: Double // e.g.: 8.0

    var current_weather: Weather

    struct Weather : Hashable, Codable {
        var temperature: Double // 16.2
        var windspeed: Double // 16.6
        var winddirection: Double // 314
        var weathercode: Int // 1
        var is_day: Int // 1
        var time: String // "2023-07-30T12:00"
    }
}

