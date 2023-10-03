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

/// A current location fetcher.
///
/// Requires `INFOPLIST_KEY_NSLocationWhenInUseUsageDescription` in `App.xcconfig` and
/// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>` in `AndroidManifest.xml`.
public class CurrentLocation : ObservableObject {
    @Published public private(set) var location: Location?
    @Published public private(set) var isFetching = false

    public init() {
    }

    @MainActor
    public func fetch() async throws {
        guard !isFetching else {
            return
        }
        isFetching = true
        defer { isFetching = false }

        #if SKIP
        let context = ProcessInfo.processInfo.androidContext
        let (latitude, longitude) = fetchCurrentLocation(context) // Defined in CustomKotlin.kt
        #else
        let (latitude, longitude) = try await locationProvider.fetchCurrentLocation()
        #endif
        location = Location(latitude: latitude, longitude: longitude)
    }

    #if !SKIP
    private let locationProvider = LocationProvider()
    #endif
}

#if !SKIP
import CoreLocation

class LocationProvider: NSObject {
    private let locationManager = CLLocationManager()
    private var completion: ((Result<(Double, Double), Error>) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func fetchCurrentLocation() async throws -> (latitude: Double, longitude: Double) {
        return try await withCheckedThrowingContinuation { continuation in
            self.completion = { result in
                switch result {
                case .success(let location):
                    continuation.resume(returning: location)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
            requestLocationOrAuthorization()
        }
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
        if completion != nil {
            requestLocationOrAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        completion?(.success((location.coordinate.latitude, location.coordinate.longitude)))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
    }
}
#endif
