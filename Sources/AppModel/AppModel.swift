import Foundation
import Combine
import OSLog

let logger = Logger(subsystem: "app.ui", category: "AppUI")

// A sample app model
public class Stuff {
    public var title = "Ahoy, Skipper!"
    public var things: [Thing] = []

    public init(count: Int = 10_000) {
        #if SKIP
        //let fmt = android.icu.text.RuleBasedNumberFormat(java.util.Locale.getDefault())
        #else
        let fmt = NumberFormatter()
        fmt.numberStyle = NumberFormatter.Style.spellOut
        #endif

        for i in 1...count {
            #if SKIP
            //let numstr = fmt.format(i)
            let numstr = "\(i)"
            #else
            let numstr = fmt.string(from: i as NSNumber) ?? ""
            #endif

            things.append(Thing(string: "Item \(numstr)", number: Double(i)))
        }
    }
}

public struct Thing : Codable {
    public let string: String
    public let number: Double

    public init(string: String, number: Double) {
        self.string = string
        self.number = number
    }
}

public extension Stuff {
    /// The list of things needed for building a successful app
    static let allThings: [Thing] = [
        Thing(string: "Build Requirements", number: 10.0),
        Thing(string: "Design User Experience", number: 20.0),
        Thing(string: "Evaluate Technologies", number: 30.0),
        //Thing(string: "Choose Skip", number: 100.0),
        Thing(string: "Develop App", number: 40.0),
        Thing(string: "Setup Continuous Integration", number: 50.0),
        Thing(string: "Deploy App Beta", number: 60.0),
        Thing(string: "Fix Bugs", number: 70.0),
        Thing(string: "Iterate on Features", number: 80.0),
        //Thing(string: "XXX", number: 100.0),
    ]
}
/// A lat/lon location (in degrees), with an optional altitude (in meters).
public struct Location : Codable {
    // Boston
    public static let `default` = Location(latitude: 42.36, longitude: -71.05)

    public var latitude: Double
    public var longitude: Double
    public var altitude: Double?

    public init(latitude: Double, longitude: Double, altitude: Double? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
    }

    func coordinates(fractionalDigits: Int? = nil) -> (latitude: Double, longitude: Double) {
        guard let fractionalDigits = fractionalDigits else {
            return (latitude, longitude)
        }
        let factor = pow(10.0, Double(fractionalDigits))
        return (latitude: Double(round(latitude * factor)) / factor, longitude: Double(round(longitude * factor)) / factor)
    }
}

@MainActor public class WeatherCondition : ObservableObject {
    /// The User-Agent header when making requests
    static let userAgent = "Demo App"

    @Published public var location: Location
    @Published public var temperature: Double?
    @Published public var lastUpdated: Date?
    @Published public var updateType: String?

    public init(location: Location, temperature: Double? = nil, lastUpdated: Date? = nil) {
        self.location = location
        self.temperature = temperature
        self.lastUpdated = lastUpdated
    }

    public func fetchWeather() async throws -> Int {
        let (lat, lon) = location.coordinates(fractionalDigits: 4)
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(lat)&longitude=\(lon)&current_weather=true")!
        logger.info("fetching URL: \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.setValue(Self.userAgent, forHTTPHeaderField: "User-Agent")
        let (data, response) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let info = try decoder.decode(WeatherResponse.self, from: data)
        self.temperature = info.current_weather.temperature
        return (response as? HTTPURLResponse)?.statusCode ?? 0
    }
}

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
