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
