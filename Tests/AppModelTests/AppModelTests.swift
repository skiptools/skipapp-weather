import XCTest
@testable import AppModel

class AppModelTests: XCTestCase {
    func testCoordinateRounding() throws {
        let location = Location(latitude: 42.36515, longitude: -71.0618)
        XCTAssertEqual(42.365, location.coordinates(fractionalDigits: 3).latitude)
        XCTAssertEqual(-71.1, location.coordinates(fractionalDigits: 1).longitude)
    }

    @MainActor func testWeather() async throws {
        let location = Location(latitude: 42.360278, longitude: -71.057778) // Boston
        let weather = WeatherCondition(location: location)
        XCTAssertNil(weather.temperature)

        let response = try await weather.fetchWeather()
        XCTAssertEqual(200, response)
        XCTAssertNotNil(weather.temperature)
    }

    @MainActor func testLocation() async throws {
        throw XCTSkip("TODO: look up current location")
    }
}
