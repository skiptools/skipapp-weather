import XCTest
@testable import SkipWeatherModel

class AppModelTests: XCTestCase {
    func testCoordinateRounding() throws {
        let location = Location(latitude: 42.36515, longitude: -71.0618)
        XCTAssertEqual(42.365, location.coordinates(fractionalDigits: 3).latitude)
        XCTAssertEqual(-71.1, location.coordinates(fractionalDigits: 1).longitude)
    }

    @MainActor func testWeather() async throws {
        let location = Location(latitude: 42.360278, longitude: -71.057778) // Boston
        let weather = WeatherCondition()
        XCTAssertNil(weather.temperature)

        let response = try await weather.fetch(at: location)
        XCTAssertEqual(200, response)
        XCTAssertNotNil(weather.temperature)
    }
}
