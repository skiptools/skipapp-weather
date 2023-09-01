import Foundation
import Combine
import OSLog

let logger = Logger(subsystem: "app.ui", category: "AppUI")

// A sample app model
public class Stuff {
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
public struct Location : Hashable, Codable {
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


public struct City {
    /// The localized name of the city
    public let cityName: LocalizedStringResource

    /// The country identifier
    public let identifier: String

    /// The localized name of the country
    public let countryName: LocalizedStringResource

    /// The ISO country code
    public let countryCode: String

    /// The location of the city
    public let location: Location

    /// The average summertime temperature in celsius (2020)
    public let averageTempSummer: Double

    /// The average wintertime temperature in celsius (2020)
    public let averageTempWinter: Double

    /// The average number of sunny days per year (2020)
    public let sunnyDays: Int
}

//extension City : CaseIterable {
//}

extension City {
    /// A sample list of major world cities
    public static let allCases: [City] = [
        City(cityName: LocalizedStringResource("Accra"),
            identifier: "GH",
            countryName: LocalizedStringResource("Ghana"),
            countryCode: "GHA",
            location: Location(latitude: 5.5600, longitude: -0.2050, altitude: 61.0),
            averageTempSummer: 28.2,
            averageTempWinter: 26.4,
            sunnyDays: 221
        ),
        City(cityName: LocalizedStringResource("Amsterdam"),
            identifier: "NL",
            countryName: LocalizedStringResource("Netherlands"),
            countryCode: "NLD",
            location: Location(latitude: 52.3676, longitude: 4.9041, altitude: -2.0),
            averageTempSummer: 18.8,
            averageTempWinter: 2.4,
            sunnyDays: 166
        ),
        City(cityName: LocalizedStringResource("Athens"),
            identifier: "GR",
            countryName: LocalizedStringResource("Greece"),
            countryCode: "GRC",
            location: Location(latitude: 37.9838, longitude: 23.7275, altitude: 170.0),
            averageTempSummer: 30.2,
            averageTempWinter: 10.1,
            sunnyDays: 279
        ),
        City(cityName: LocalizedStringResource("Auckland"),
            identifier: "NZ",
            countryName: LocalizedStringResource("New Zealand"),
            countryCode: "NZL",
            location: Location(latitude: -36.8485, longitude: 174.7633, altitude: 1.0),
            averageTempSummer: 22.4,
            averageTempWinter: 15.1,
            sunnyDays: 205
        ),
        City(cityName: LocalizedStringResource("Bangkok"),
            identifier: "TH",
            countryName: LocalizedStringResource("Thailand"),
            countryCode: "THA",
            location: Location(latitude: 13.7563, longitude: 100.5018, altitude: 1.5),
            averageTempSummer: 31.8,
            averageTempWinter: 26.3,
            sunnyDays: 260
        ),
        City(cityName: LocalizedStringResource("Barcelona"),
            identifier: "ES",
            countryName: LocalizedStringResource("Spain"),
            countryCode: "ESP",
            location: Location(latitude: 41.3851, longitude: 2.1734, altitude: 12.0),
            averageTempSummer: 27.9,
            averageTempWinter: 12.5,
            sunnyDays: 244
        ),
        City(cityName: LocalizedStringResource("Berlin"),
            identifier: "DE",
            countryName: LocalizedStringResource("Germany"),
            countryCode: "DEU",
            location: Location(latitude: 52.5200, longitude: 13.4050, altitude: 34.0),
            averageTempSummer: 23.3,
            averageTempWinter: 1.6,
            sunnyDays: 163
        ),
        City(cityName: LocalizedStringResource("Birmingham"),
            identifier: "GB",
            countryName: LocalizedStringResource("United Kingdom"),
            countryCode: "GBR",
            location: Location(latitude: 52.4862, longitude: -1.8904, altitude: 140.0),
            averageTempSummer: 18.6,
            averageTempWinter: 2.2,
            sunnyDays: 126
        ),
        City(cityName: LocalizedStringResource("Boston"),
            identifier: "US",
            countryName: LocalizedStringResource("United States"),
            countryCode: "USA",
            location: Location(latitude: 42.3601, longitude: -71.0589, altitude: 43.0),
            averageTempSummer: 24.0,
            averageTempWinter: 3.3,
            sunnyDays: 217
        ),
        City(cityName: LocalizedStringResource("Buenos Aires"),
            identifier: "AR",
            countryName: LocalizedStringResource("Argentina"),
            countryCode: "ARG",
            location: Location(latitude: -34.6118, longitude: -58.4173, altitude: 25.0),
            averageTempSummer: 27.5,
            averageTempWinter: 14.4,
            sunnyDays: 199
        ),
        City(cityName: LocalizedStringResource("Cape Town"),
            identifier: "ZA",
            countryName: LocalizedStringResource("South Africa"),
            countryCode: "ZAF",
            location: Location(latitude: -33.9249, longitude: 18.4241, altitude: 1.0),
            averageTempSummer: 23.7,
            averageTempWinter: 14.1,
            sunnyDays: 365
        ),
        City(cityName: LocalizedStringResource("Chicago"),
            identifier: "US",
            countryName: LocalizedStringResource("United States"),
            countryCode: "USA",
            location: Location(latitude: 41.8781, longitude: -87.6298, altitude: 181.0),
            averageTempSummer: 24.4,
            averageTempWinter: -1.2,
            sunnyDays: 186
        ),
        City(cityName: LocalizedStringResource("Copenhagen"),
            identifier: "DK",
            countryName: LocalizedStringResource("Denmark"),
            countryCode: "DNK",
            location: Location(latitude: 55.6761, longitude: 12.5683, altitude: 5.0),
            averageTempSummer: 20.2,
            averageTempWinter: 1.1,
            sunnyDays: 164
        ),
        City(cityName: LocalizedStringResource("Delhi"),
            identifier: "IN",
            countryName: LocalizedStringResource("India"),
            countryCode: "IND",
            location: Location(latitude: 28.6139, longitude: 77.2090, altitude: 213.0),
            averageTempSummer: 34.7,
            averageTempWinter: 15.5,
            sunnyDays: 267
        ),
        City(cityName: LocalizedStringResource("Dublin"),
            identifier: "IE",
            countryName: LocalizedStringResource("Ireland"),
            countryCode: "IRL",
            location: Location(latitude: 53.3498, longitude: -6.2603, altitude: 20.0),
            averageTempSummer: 17.5,
            averageTempWinter: 5.2,
            sunnyDays: 147
        ),
        City(cityName: LocalizedStringResource("Edinburgh"),
            identifier: "GB",
            countryName: LocalizedStringResource("United Kingdom"),
            countryCode: "GBR",
            location: Location(latitude: 55.9533, longitude: -3.1883, altitude: 57.0),
            averageTempSummer: 16.2,
            averageTempWinter: 4.0,
            sunnyDays: 111
        ),
        City(cityName: LocalizedStringResource("Glasgow"),
            identifier: "GB",
            countryName: LocalizedStringResource("United Kingdom"),
            countryCode: "GBR",
            location: Location(latitude: 55.8642, longitude: -4.2518, altitude: 26.0),
            averageTempSummer: 16.5,
            averageTempWinter: 4.5,
            sunnyDays: 119
        ),
        City(cityName: LocalizedStringResource("Prague"),
            identifier: "CZ",
            countryName: LocalizedStringResource("Czech Republic"),
            countryCode: "CZE",
            location: Location(latitude: 50.0755, longitude: 14.4378, altitude: 177.0),
            averageTempSummer: 21.1,
            averageTempWinter: 0.7,
            sunnyDays: 185
        ),
        City(cityName: LocalizedStringResource("Marrakech"),
            identifier: "MA",
            countryName: LocalizedStringResource("Morocco"),
            countryCode: "MAR",
            location: Location(latitude: 31.6295, longitude: -7.9811, altitude: 466.0),
            averageTempSummer: 37.7,
            averageTempWinter: 12.8,
            sunnyDays: 292
        ),
        City(cityName: LocalizedStringResource("Montreal"),
            identifier: "CA",
            countryName: LocalizedStringResource("Canada"),
            countryCode: "CAN",
            location: Location(latitude: 45.5017, longitude: -73.5673, altitude: 37.0),
            averageTempSummer: 24.0,
            averageTempWinter: -4.5,
            sunnyDays: 154
        ),
        City(cityName: LocalizedStringResource("Madrid"),
            identifier: "ES",
            countryName: LocalizedStringResource("Spain"),
            countryCode: "ESP",
            location: Location(latitude: 40.4168, longitude: -3.7038, altitude: 667.0),
            averageTempSummer: 31.6,
            averageTempWinter: 8.0,
            sunnyDays: 281
        ),
        City(cityName: LocalizedStringResource("Manchester"),
            identifier: "GB",
            countryName: LocalizedStringResource("United Kingdom"),
            countryCode: "GBR",
            location: Location(latitude: 53.4830, longitude: -2.2441, altitude: 38.0),
            averageTempSummer: 16.7,
            averageTempWinter: 3.0,
            sunnyDays: 130
        ),
        City(cityName: LocalizedStringResource("Mumbai"),
            identifier: "IN",
            countryName: LocalizedStringResource("India"),
            countryCode: "IND",
            location: Location(latitude: 19.0760, longitude: 72.8777, altitude: 14.0),
            averageTempSummer: 30.2,
            averageTempWinter: 25.4,
            sunnyDays: 287
        ),
        City(cityName: LocalizedStringResource("Taipei"),
            identifier: "TW",
            countryName: LocalizedStringResource("Taiwan"),
            countryCode: "TWN",
            location: Location(latitude: 25.0320, longitude: 121.5654, altitude: 9.0),
            averageTempSummer: 30.7,
            averageTempWinter: 16.1,
            sunnyDays: 189
        ),
        City(cityName: LocalizedStringResource("London"),
            identifier: "GB",
            countryName: LocalizedStringResource("United Kingdom"),
            countryCode: "GBR",
            location: Location(latitude: 51.5074, longitude: -0.1278, altitude: 25.0),
            averageTempSummer: 19.0,
            averageTempWinter: 4.4,
            sunnyDays: 151
        ),
        City(cityName: LocalizedStringResource("Porto"),
            identifier: "PT",
            countryName: LocalizedStringResource("Portugal"),
            countryCode: "PRT",
            location: Location(latitude: 41.1579, longitude: -8.6291, altitude: 83.0),
            averageTempSummer: 21.7,
            averageTempWinter: 9.2,
            sunnyDays: 229
        ),
        City(cityName: LocalizedStringResource("Houston"),
            identifier: "US",
            countryName: LocalizedStringResource("United States"),
            countryCode: "USA",
            location: Location(latitude: 29.7604, longitude: -95.3698, altitude: 14.0),
            averageTempSummer: 31.1,
            averageTempWinter: 14.1,
            sunnyDays: 204
        ),
        City(cityName: LocalizedStringResource("Lyon"),
            identifier: "FR",
            countryName: LocalizedStringResource("France"),
            countryCode: "FRA",
            location: Location(latitude: 45.75, longitude: 4.85, altitude: 173.0),
            averageTempSummer: 25.8,
            averageTempWinter: 2.3,
            sunnyDays: 213
        ),
        City(cityName: LocalizedStringResource("Medellín"),
            identifier: "CO",
            countryName: LocalizedStringResource("Colombia"),
            countryCode: "COL",
            location: Location(latitude: 6.2442, longitude: -75.5812, altitude: 1495.0),
            averageTempSummer: 22.2,
            averageTempWinter: 21.7,
            sunnyDays: 178
        ),
        City(cityName: LocalizedStringResource("Melbourne"),
            identifier: "AU",
            countryName: LocalizedStringResource("Australia"),
            countryCode: "AUS",
            location: Location(latitude: -37.8136, longitude: 144.9631, altitude: 31.0),
            averageTempSummer: 23.5,
            averageTempWinter: 14.0,
            sunnyDays: 127
        ),
        City(cityName: LocalizedStringResource("New York"),
            identifier: "US",
            countryName: LocalizedStringResource("United States"),
            countryCode: "USA",
            location: Location(latitude: 40.7128, longitude: -74.0060, altitude: 14.0),
            averageTempSummer: 26.9,
            averageTempWinter: 2.6,
            sunnyDays: 234
        ),
        City(cityName: LocalizedStringResource("Stockholm"),
            identifier: "SE",
            countryName: LocalizedStringResource("Sweden"),
            countryCode: "SWE",
            location: Location(latitude: 59.3293, longitude: 18.0686, altitude: 44.0),
            averageTempSummer: 21.0,
            averageTempWinter: -0.9,
            sunnyDays: 206
        ),
        City(cityName: LocalizedStringResource("San Francisco"),
            identifier: "US",
            countryName: LocalizedStringResource("United States"),
            countryCode: "USA",
            location: Location(latitude: 37.7749, longitude: -122.4194, altitude: 16.0),
            averageTempSummer: 17.7,
            averageTempWinter: 11.5,
            sunnyDays: 259
        ),
        City(cityName: LocalizedStringResource("Tokyo"),
            identifier: "JP",
            countryName: LocalizedStringResource("Japan"),
            countryCode: "JPN",
            location: Location(latitude: 35.6895, longitude: 139.6917, altitude: 131.0),
            averageTempSummer: 27.6,
            averageTempWinter: 6.5,
            sunnyDays: 158
        ),
        City(cityName: LocalizedStringResource("Toronto"),
            identifier: "CA",
            countryName: LocalizedStringResource("Canada"),
            countryCode: "CAN",
            location: Location(latitude: 43.6532, longitude: -79.3832, altitude: 76.0),
            averageTempSummer: 22.2,
            averageTempWinter: -0.7,
            sunnyDays: 221
        ),
        City(cityName: LocalizedStringResource("Lisbon"),
            identifier: "PT",
            countryName: LocalizedStringResource("Portugal"),
            countryCode: "PRT",
            location: Location(latitude: 38.7223, longitude: -9.1393, altitude: 2.0),
            averageTempSummer: 27.1,
            averageTempWinter: 11.4,
            sunnyDays: 276
        ),
        City(cityName: LocalizedStringResource("Mexico City"),
            identifier: "MX",
            countryName: LocalizedStringResource("Mexico"),
            countryCode: "MEX",
            location: Location(latitude: 19.4326, longitude: -99.1332, altitude: 2240.0),
            averageTempSummer: 19.4,
            averageTempWinter: 13.2,
            sunnyDays: 225
        ),
        City(cityName: LocalizedStringResource("Tel Aviv"),
            identifier: "IL",
            countryName: LocalizedStringResource("Israel"),
            countryCode: "ISR",
            location: Location(latitude: 32.0853, longitude: 34.7818, altitude: 8.0),
            averageTempSummer: 29.0,
            averageTempWinter: 15.6,
            sunnyDays: 322
        ),
        City(cityName: LocalizedStringResource("Paris"),
            identifier: "FR",
            countryName: LocalizedStringResource("France"),
            countryCode: "FRA",
            location: Location(latitude: 48.8566, longitude: 2.3522, altitude: 34.0),
            averageTempSummer: 25.7,
            averageTempWinter: 5.8,
            sunnyDays: 166
        ),
        City(cityName: LocalizedStringResource("Kuala Lumpur"),
            identifier: "MY",
            countryName: LocalizedStringResource("Malaysia"),
            countryCode: "MYS",
            location: Location(latitude: 3.1390, longitude: 101.6869, altitude: 21.0),
            averageTempSummer: 31.5,
            averageTempWinter: 25.3,
            sunnyDays: 202
        ),
        City(cityName: LocalizedStringResource("Manila"),
            identifier: "PH",
            countryName: LocalizedStringResource("Philippines"),
            countryCode: "PHL",
            location: Location(latitude: 14.5995, longitude: 120.9842, altitude: 16.0),
            averageTempSummer: 31.9,
            averageTempWinter: 25.9,
            sunnyDays: 213
        ),
        City(cityName: LocalizedStringResource("São Paulo"),
            identifier: "BR",
            countryName: LocalizedStringResource("Brazil"),
            countryCode: "BRA",
            location: Location(latitude: -23.5505, longitude: -46.6333, altitude: 760.0),
            averageTempSummer: 22.4,
            averageTempWinter: 15.5,
            sunnyDays: 186
        ),
        City(cityName: LocalizedStringResource("Miami"),
            identifier: "US",
            countryName: LocalizedStringResource("United States"),
            countryCode: "USA",
            location: Location(latitude: 25.7617, longitude: -80.1918, altitude: 1.0),
            averageTempSummer: 29.0,
            averageTempWinter: 20.0,
            sunnyDays: 249
        ),
        City(cityName: LocalizedStringResource("Rome"),
            identifier: "IT",
            countryName: LocalizedStringResource("Italy"),
            countryCode: "ITA",
            location: Location(latitude: 41.9028, longitude: 12.4964, altitude: 13.0),
            averageTempSummer: 27.7,
            averageTempWinter: 8.2,
            sunnyDays: 250
        ),
        City(cityName: LocalizedStringResource("Los Angeles"),
            identifier: "US",
            countryName: LocalizedStringResource("United States"),
            countryCode: "USA",
            location: Location(latitude: 34.0522, longitude: -118.2437, altitude: 71.0),
            averageTempSummer: 23.9,
            averageTempWinter: 13.8,
            sunnyDays: 284
        ),
        City(cityName: LocalizedStringResource("Singapore"),
            identifier: "SG",
            countryName: LocalizedStringResource("Singapore"),
            countryCode: "SGP",
            location: Location(latitude: 1.3521, longitude: 103.8198, altitude: 15.0),
            averageTempSummer: 31.0,
            averageTempWinter: 26.5,
            sunnyDays: 170
        ),
        City(cityName: LocalizedStringResource("Sydney"),
            identifier: "AU",
            countryName: LocalizedStringResource("Australia"),
            countryCode: "AUS",
            location: Location(latitude: -33.8688, longitude: 151.2093, altitude: 3.0),
            averageTempSummer: 25.8,
            averageTempWinter: 14.8,
            sunnyDays: 261
        ),
        City(cityName: LocalizedStringResource("Rio de Janeiro"),
            identifier: "BR",
            countryName: LocalizedStringResource("Brazil"),
            countryCode: "BRA",
            location: Location(latitude: -22.9068, longitude: -43.1729, altitude: 6.0),
            averageTempSummer: 29.8,
            averageTempWinter: 22.6,
            sunnyDays: 218
        ),
        City(cityName: LocalizedStringResource("Johannesburg"),
            identifier: "ZA",
            countryName: LocalizedStringResource("South Africa"),
            countryCode: "ZAF",
            location: Location(latitude: -26.2041, longitude: 28.0473, altitude: 1753.0),
            averageTempSummer: 24.8,
            averageTempWinter: 13.0,
            sunnyDays: 281
        ),
        City(cityName: LocalizedStringResource("Istanbul"),
            identifier: "TR",
            countryName: LocalizedStringResource("Turkey"),
            countryCode: "TUR",
            location: Location(latitude: 41.0082, longitude: 28.9784, altitude: 30.0),
            averageTempSummer: 26.6,
            averageTempWinter: 9.8,
            sunnyDays: 281
        ),
    ]
}
