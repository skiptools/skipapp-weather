import Foundation
import Combine
import SkipDevice

public class WeatherCondition : ObservableObject {
    /// The User-Agent header when making requests
    static let userAgent = "Demo App"

    @Published public private(set) var location: Location?
    @Published public private(set) var temperature: Double?
    @Published public private(set) var isFetching = false
    private var fetchCount = 0 {
        didSet {
            isFetching = fetchCount > 0
        }
    }

    public init() {
    }

    func locationEquals(_ l1: Location?, _ l2: Location?) -> Bool {
        if l1?.latitude != l2?.latitude { return false }
        if l1?.longitude != l2?.longitude { return false }
        return true
    }

    @MainActor
    @discardableResult public func fetch(at location: Location) async throws -> Int {
        if !locationEquals(location, self.location) {
            self.location = location
            temperature = nil
        }
        fetchCount += 1
        defer { fetchCount -= 1 }

        let (lat, lon) = location.coordinates(fractionalDigits: 4)
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true")!
        logger.info("fetching URL: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.setValue(Self.userAgent, forHTTPHeaderField: "User-Agent")
        let (data, response) = try await URLSession.shared.data(for: request)
        // guard against updating for an old request
        if locationEquals(location, self.location) {
            let decoder = JSONDecoder()
            let info = try decoder.decode(WeatherResponse.self, from: data)
            temperature = info.current_weather.temperature
        }
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        logger.info("response status code: \(String(describing: statusCode))")
        return statusCode ?? 0
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
