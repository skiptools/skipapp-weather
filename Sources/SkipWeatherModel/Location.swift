import Foundation
import Combine
import SkipDevice

/// A current location fetcher.
///
/// Requires `INFOPLIST_KEY_NSLocationWhenInUseUsageDescription` in `App.xcconfig` and
/// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>` in `AndroidManifest.xml`.
public class CurrentLocation : ObservableObject {
    @Published public private(set) var location: Location?
    @Published public private(set) var isFetching = false
    private let locationProvider = LocationProvider()

    public init() {
    }

    @MainActor
    public func fetch() async throws {
        guard !isFetching else { return }
        isFetching = true
        defer { isFetching = false }
        self.location = try await locationProvider.fetchCurrentLocation()
    }
}
