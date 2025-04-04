import Foundation
import SkipDevice

public struct City {
    /// The localized name of the city
    public let cityName: String

    /// The country identifier
    public let identifier: String

    /// The localized name of the country
    public let countryName: String

    /// The ISO country code
    public let countryCode: String

    /// The name of the icon symbol to use for the city
    public let symbolName: String

    /// The location of the city
    public let location: Location

    /// The average summertime temperature in celsius (2020)
    public let averageTempSummer: Double

    /// The average wintertime temperature in celsius (2020)
    public let averageTempWinter: Double

    /// The average number of sunny days per year (2020)
    public let sunnyDays: Int
}

extension City: Hashable {
    public static func ==(lhs: City, rhs: City) -> Bool {
        return lhs.cityName == rhs.cityName
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(cityName)
    }
}


public struct Location {
    public let latitude: Double
    public let longitude: Double

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// Returns the closest City from the Location
    public var nearestCity: City {
        City.allCases.sorted(by: {
            $0.location.distance(from: self) < $1.location.distance(from: self)
        }).first!
    }

    public func coordinates(fractionalDigits: Int? = nil) -> (latitude: Double, longitude: Double) {
        guard let fractionalDigits = fractionalDigits else {
            return (latitude, longitude)
        }
        let factor = pow(10.0, Double(fractionalDigits))
        return (latitude: Double(round(latitude * factor)) / factor, longitude: Double(round(longitude * factor)) / factor)
    }

    /// Calculate the distance from another Location using the Haversine formula and returns the distance in kilometers
    public func distance(from location: Location) -> Double {
        let lat1 = self.latitude
        let lon1 = self.longitude
        let lat2 = location.latitude
        let lon2 = location.longitude

        let dLat = (lat2 - lat1).toRadians
        let dLon = (lon2 - lon1).toRadians

        let slat: Double = sin(dLat / 2.0)
        let slon: Double = sin(dLon / 2.0)
        let a: Double = slat * slat + cos(lat1.toRadians) * cos(lat2.toRadians) * slon * slon
        let c: Double = 2.0 * atan2(sqrt(a), sqrt(1.0 - a))

        return c * 6371.0 // earthRadiusKilometers
    }
}

extension Double {
    var toRadians: Double {
        return self * .pi / 180.0
    }
}

extension City {
    /// A sample list of major world cities
    public static let allCases: [City] = [
        City(cityName: "Accra",
             identifier: "GH",
             countryName: "Ghana",
             countryCode: "GHA",
             symbolName: "face.smiling",
             location: Location(latitude: 5.5600, longitude: -0.2050),
             averageTempSummer: 28.2,
             averageTempWinter: 26.4,
             sunnyDays: 221
            ),
        City(cityName: "Amsterdam",
             identifier: "NL",
             countryName: "Netherlands",
             countryCode: "NLD",
             symbolName: "hand.thumbsup",
             location: Location(latitude: 52.3676, longitude: 4.9041),
             averageTempSummer: 18.8,
             averageTempWinter: 2.4,
             sunnyDays: 166
            ),
        City(cityName: "Athens",
             identifier: "GR",
             countryName: "Greece",
             countryCode: "GRC",
             symbolName: "calendar",
             location: Location(latitude: 37.9838, longitude: 23.7275),
             averageTempSummer: 30.2,
             averageTempWinter: 10.1,
             sunnyDays: 279
            ),
        City(cityName: "Auckland",
             identifier: "NZ",
             countryName: "New Zealand",
             countryCode: "NZL",
             symbolName: "checkmark.circle",
             location: Location(latitude: -36.8485, longitude: 174.7633),
             averageTempSummer: 22.4,
             averageTempWinter: 15.1,
             sunnyDays: 205
            ),
        City(cityName: "Bangkok",
             identifier: "TH",
             countryName: "Thailand",
             countryCode: "THA",
             symbolName: "arrow.clockwise.circle",
             location: Location(latitude: 13.7563, longitude: 100.5018),
             averageTempSummer: 31.8,
             averageTempWinter: 26.3,
             sunnyDays: 260
            ),
        City(cityName: "Barcelona",
             identifier: "ES",
             countryName: "Spain",
             countryCode: "ESP",
             symbolName: "envelope.fill",
             location: Location(latitude: 41.3851, longitude: 2.1734),
             averageTempSummer: 27.9,
             averageTempWinter: 12.5,
             sunnyDays: 244
            ),
        City(cityName: "Berlin",
             identifier: "DE",
             countryName: "Germany",
             countryCode: "DEU",
             symbolName: "star.fill",
             location: Location(latitude: 52.5200, longitude: 13.4050),
             averageTempSummer: 23.3,
             averageTempWinter: 1.6,
             sunnyDays: 163
            ),
        City(cityName: "Birmingham",
             identifier: "GB",
             countryName: "United Kingdom",
             countryCode: "GBR",
             symbolName: "plus.circle.fill",
             location: Location(latitude: 52.4862, longitude: -1.8904),
             averageTempSummer: 18.6,
             averageTempWinter: 2.2,
             sunnyDays: 126
            ),
        City(cityName: "Boston",
             identifier: "US",
             countryName: "United States",
             countryCode: "USA",
             symbolName: "heart.fill",
             location: Location(latitude: 42.3601, longitude: -71.0589),
             averageTempSummer: 24.0,
             averageTempWinter: 3.3,
             sunnyDays: 217
            ),
        City(cityName: "Buenos Aires",
             identifier: "AR",
             countryName: "Argentina",
             countryCode: "ARG",
             symbolName: "paperplane.fill",
             location: Location(latitude: -34.6118, longitude: -58.4173),
             averageTempSummer: 27.5,
             averageTempWinter: 14.4,
             sunnyDays: 199
            ),
        City(cityName: "Cape Town",
             identifier: "ZA",
             countryName: "South Africa",
             countryCode: "ZAF",
             symbolName: "envelope",
             location: Location(latitude: -33.9249, longitude: 18.4241),
             averageTempSummer: 23.7,
             averageTempWinter: 14.1,
             sunnyDays: 365
            ),
        City(cityName: "Chicago",
             identifier: "US",
             countryName: "United States",
             countryCode: "USA",
             symbolName: "mappin.circle",
             location: Location(latitude: 41.8781, longitude: -87.6298),
             averageTempSummer: 24.4,
             averageTempWinter: -1.2,
             sunnyDays: 186
            ),
        City(cityName: "Copenhagen",
             identifier: "DK",
             countryName: "Denmark",
             countryCode: "DNK",
             symbolName: "person.crop.circle.fill",
             location: Location(latitude: 55.6761, longitude: 12.5683),
             averageTempSummer: 20.2,
             averageTempWinter: 1.1,
             sunnyDays: 164
            ),
        City(cityName: "Delhi",
             identifier: "IN",
             countryName: "India",
             countryCode: "IND",
             symbolName: "bell.fill",
             location: Location(latitude: 28.6139, longitude: 77.2090),
             averageTempSummer: 34.7,
             averageTempWinter: 15.5,
             sunnyDays: 267
            ),
        City(cityName: "Dublin",
             identifier: "IE",
             countryName: "Ireland",
             countryCode: "IRL",
             symbolName: "star.fill",
             location: Location(latitude: 53.3498, longitude: -6.2603),
             averageTempSummer: 17.5,
             averageTempWinter: 5.2,
             sunnyDays: 147
            ),
        City(cityName: "Edinburgh",
             identifier: "GB",
             countryName: "United Kingdom",
             countryCode: "GBR",
             symbolName: "bell.fill",
             location: Location(latitude: 55.9533, longitude: -3.1883),
             averageTempSummer: 16.2,
             averageTempWinter: 4.0,
             sunnyDays: 111
            ),
        City(cityName: "Glasgow",
             identifier: "GB",
             countryName: "United Kingdom",
             countryCode: "GBR",
             symbolName: "bell.fill",
             location: Location(latitude: 55.8642, longitude: -4.2518),
             averageTempSummer: 16.5,
             averageTempWinter: 4.5,
             sunnyDays: 119
            ),
        City(cityName: "Prague",
             identifier: "CZ",
             countryName: "Czech Republic",
             countryCode: "CZE",
             symbolName: "location",
             location: Location(latitude: 50.0755, longitude: 14.4378),
             averageTempSummer: 21.1,
             averageTempWinter: 0.7,
             sunnyDays: 185
            ),
        City(cityName: "Marrakech",
             identifier: "MA",
             countryName: "Morocco",
             countryCode: "MAR",
             symbolName: "cart",
             location: Location(latitude: 31.6295, longitude: -7.9811),
             averageTempSummer: 37.7,
             averageTempWinter: 12.8,
             sunnyDays: 292
            ),
        City(cityName: "Montreal",
             identifier: "CA",
             countryName: "Canada",
             countryCode: "CAN",
             symbolName: "person.crop.square.fill",
             location: Location(latitude: 45.5017, longitude: -73.5673),
             averageTempSummer: 24.0,
             averageTempWinter: -4.5,
             sunnyDays: 154
            ),
        City(cityName: "Madrid",
             identifier: "ES",
             countryName: "Spain",
             countryCode: "ESP",
             symbolName: "paperplane.fill",
             location: Location(latitude: 40.4168, longitude: -3.7038),
             averageTempSummer: 31.6,
             averageTempWinter: 8.0,
             sunnyDays: 281
            ),
        City(cityName: "Manchester",
             identifier: "GB",
             countryName: "United Kingdom",
             countryCode: "GBR",
             symbolName: "person.crop.circle.fill",
             location: Location(latitude: 53.4830, longitude: -2.2441),
             averageTempSummer: 16.7,
             averageTempWinter: 3.0,
             sunnyDays: 130
            ),
        City(cityName: "Mumbai",
             identifier: "IN",
             countryName: "India",
             countryCode: "IND",
             symbolName: "mappin.circle",
             location: Location(latitude: 19.0760, longitude: 72.8777),
             averageTempSummer: 30.2,
             averageTempWinter: 25.4,
             sunnyDays: 287
            ),
        City(cityName: "Taipei",
             identifier: "TW",
             countryName: "Taiwan",
             countryCode: "TWN",
             symbolName: "envelope",
             location: Location(latitude: 25.0320, longitude: 121.5654),
             averageTempSummer: 30.7,
             averageTempWinter: 16.1,
             sunnyDays: 189
            ),
        City(cityName: "London",
             identifier: "GB",
             countryName: "United Kingdom",
             countryCode: "GBR",
             symbolName: "cart.fill",
             location: Location(latitude: 51.5074, longitude: -0.1278),
             averageTempSummer: 19.0,
             averageTempWinter: 4.4,
             sunnyDays: 151
            ),
        City(cityName: "Porto",
             identifier: "PT",
             countryName: "Portugal",
             countryCode: "PRT",
             symbolName: "bell.fill",
             location: Location(latitude: 41.1579, longitude: -8.6291),
             averageTempSummer: 21.7,
             averageTempWinter: 9.2,
             sunnyDays: 229
            ),
        City(cityName: "Houston",
             identifier: "US",
             countryName: "United States",
             countryCode: "USA",
             symbolName: "location",
             location: Location(latitude: 29.7604, longitude: -95.3698),
             averageTempSummer: 31.1,
             averageTempWinter: 14.1,
             sunnyDays: 204
            ),
        City(cityName: "Lyon",
             identifier: "FR",
             countryName: "France",
             countryCode: "FRA",
             symbolName: "bell.fill",
             location: Location(latitude: 45.75, longitude: 4.85),
             averageTempSummer: 25.8,
             averageTempWinter: 2.3,
             sunnyDays: 213
            ),
        City(cityName: "Medellín",
             identifier: "CO",
             countryName: "Colombia",
             countryCode: "COL",
             symbolName: "envelope",
             location: Location(latitude: 6.2442, longitude: -75.5812),
             averageTempSummer: 22.2,
             averageTempWinter: 21.7,
             sunnyDays: 178
            ),
        City(cityName: "Melbourne",
             identifier: "AU",
             countryName: "Australia",
             countryCode: "AUS",
             symbolName: "paperplane.fill",
             location: Location(latitude: -37.8136, longitude: 144.9631),
             averageTempSummer: 23.5,
             averageTempWinter: 14.0,
             sunnyDays: 127
            ),
        City(cityName: "New York",
             identifier: "US",
             countryName: "United States",
             countryCode: "USA",
             symbolName: "mappin.circle",
             location: Location(latitude: 40.7128, longitude: -74.0060),
             averageTempSummer: 26.9,
             averageTempWinter: 2.6,
             sunnyDays: 234
            ),
        City(cityName: "Stockholm",
             identifier: "SE",
             countryName: "Sweden",
             countryCode: "SWE",
             symbolName: "person.crop.square.fill",
             location: Location(latitude: 59.3293, longitude: 18.0686),
             averageTempSummer: 21.0,
             averageTempWinter: -0.9,
             sunnyDays: 206
            ),
        City(cityName: "San Francisco",
             identifier: "US",
             countryName: "United States",
             countryCode: "USA",
             symbolName: "mappin.circle.fill",
             location: Location(latitude: 37.7749, longitude: -122.4194),
             averageTempSummer: 17.7,
             averageTempWinter: 11.5,
             sunnyDays: 259
            ),
        City(cityName: "Tokyo",
             identifier: "JP",
             countryName: "Japan",
             countryCode: "JPN",
             symbolName: "bell.fill",
             location: Location(latitude: 35.6895, longitude: 139.6917),
             averageTempSummer: 27.6,
             averageTempWinter: 6.5,
             sunnyDays: 158
            ),
        City(cityName: "Toronto",
             identifier: "CA",
             countryName: "Canada",
             countryCode: "CAN",
             symbolName: "location",
             location: Location(latitude: 43.6532, longitude: -79.3832),
             averageTempSummer: 22.2,
             averageTempWinter: -0.7,
             sunnyDays: 221
            ),
        City(cityName: "Lisbon",
             identifier: "PT",
             countryName: "Portugal",
             countryCode: "PRT",
             symbolName: "cart.fill",
             location: Location(latitude: 38.7223, longitude: -9.1393),
             averageTempSummer: 27.1,
             averageTempWinter: 11.4,
             sunnyDays: 276
            ),
        City(cityName: "Mexico City",
             identifier: "MX",
             countryName: "Mexico",
             countryCode: "MEX",
             symbolName: "paperplane.fill",
             location: Location(latitude: 19.4326, longitude: -99.1332),
             averageTempSummer: 19.4,
             averageTempWinter: 13.2,
             sunnyDays: 225
            ),
        City(cityName: "Tel Aviv",
             identifier: "IL",
             countryName: "Israel",
             countryCode: "ISR",
             symbolName: "wrench.fill",
             location: Location(latitude: 32.0853, longitude: 34.7818),
             averageTempSummer: 29.0,
             averageTempWinter: 15.6,
             sunnyDays: 322
            ),
        City(cityName: "Paris",
             identifier: "FR",
             countryName: "France",
             countryCode: "FRA",
             symbolName: "star.fill",
             location: Location(latitude: 48.8566, longitude: 2.3522),
             averageTempSummer: 25.7,
             averageTempWinter: 5.8,
             sunnyDays: 166
            ),
        City(cityName: "Kuala Lumpur",
             identifier: "MY",
             countryName: "Malaysia",
             countryCode: "MYS",
             symbolName: "location",
             location: Location(latitude: 3.1390, longitude: 101.6869),
             averageTempSummer: 31.5,
             averageTempWinter: 25.3,
             sunnyDays: 202
            ),
        City(cityName: "Manila",
             identifier: "PH",
             countryName: "Philippines",
             countryCode: "PHL",
             symbolName: "paperplane.fill",
             location: Location(latitude: 14.5995, longitude: 120.9842),
             averageTempSummer: 31.9,
             averageTempWinter: 25.9,
             sunnyDays: 213
            ),
        City(cityName: "São Paulo",
             identifier: "BR",
             countryName: "Brazil",
             countryCode: "BRA",
             symbolName: "phone.fill",
             location: Location(latitude: -23.5505, longitude: -46.6333),
             averageTempSummer: 22.4,
             averageTempWinter: 15.5,
             sunnyDays: 186
            ),
        City(cityName: "Miami",
             identifier: "US",
             countryName: "United States",
             countryCode: "USA",
             symbolName: "person.crop.square.fill",
             location: Location(latitude: 25.7617, longitude: -80.1918),
             averageTempSummer: 29.0,
             averageTempWinter: 20.0,
             sunnyDays: 249
            ),
        City(cityName: "Rome",
             identifier: "IT",
             countryName: "Italy",
             countryCode: "ITA",
             symbolName: "location",
             location: Location(latitude: 41.9028, longitude: 12.4964),
             averageTempSummer: 27.7,
             averageTempWinter: 8.2,
             sunnyDays: 250
            ),
        City(cityName: "Los Angeles",
             identifier: "US",
             countryName: "United States",
             countryCode: "USA",
             symbolName: "mappin.circle.fill",
             location: Location(latitude: 34.0522, longitude: -118.2437),
             averageTempSummer: 23.9,
             averageTempWinter: 13.8,
             sunnyDays: 284
            ),
        City(cityName: "Singapore",
             identifier: "SG",
             countryName: "Singapore",
             countryCode: "SGP",
             symbolName: "cart.fill",
             location: Location(latitude: 1.3521, longitude: 103.8198),
             averageTempSummer: 31.0,
             averageTempWinter: 26.5,
             sunnyDays: 170
            ),
        City(cityName: "Sydney",
             identifier: "AU",
             countryName: "Australia",
             countryCode: "AUS",
             symbolName: "bell.fill",
             location: Location(latitude: -33.8688, longitude: 151.2093),
             averageTempSummer: 25.8,
             averageTempWinter: 14.8,
             sunnyDays: 261
            ),
        City(cityName: "Rio de Janeiro",
             identifier: "BR",
             countryName: "Brazil",
             countryCode: "BRA",
             symbolName: "person.crop.square.fill",
             location: Location(latitude: -22.9068, longitude: -43.1729),
             averageTempSummer: 29.8,
             averageTempWinter: 22.6,
             sunnyDays: 218
            ),
        City(cityName: "Johannesburg",
             identifier: "ZA",
             countryName: "South Africa",
             countryCode: "ZAF",
             symbolName: "phone.fill",
             location: Location(latitude: -26.2041, longitude: 28.0473),
             averageTempSummer: 24.8,
             averageTempWinter: 13.0,
             sunnyDays: 281
            ),
        City(cityName: "Istanbul",
             identifier: "TR",
             countryName: "Turkey",
             countryCode: "TUR",
             symbolName: "phone.fill",
             location: Location(latitude: 41.0082, longitude: 28.9784),
             averageTempSummer: 26.6,
             averageTempWinter: 9.8,
             sunnyDays: 281
            ),
    ].sorted(by: { c1, c2 in
        c1.cityName < c2.cityName
    })
}
