import XCTest
import OSLog
import Foundation
@testable import SkipWeatherModel

let logger: Logger = Logger(subsystem: "SkipWeatherModel", category: "Tests")

@available(macOS 13, *)
final class SkipWeatherModelTests: XCTestCase {
    func testSkipWeatherModel() throws {
        logger.log("running testSkipWeatherModel")
        XCTAssertEqual(1 + 2, 3, "basic test")
        
        // load the TestData.json file from the Resources folder and decode it into a struct
        let resourceURL: URL = try XCTUnwrap(Bundle.module.url(forResource: "TestData", withExtension: "json"))
        let testData = try JSONDecoder().decode(TestData.self, from: Data(contentsOf: resourceURL))
        XCTAssertEqual("SkipWeatherModel", testData.testModuleName)
    }
}

struct TestData : Codable, Hashable {
    var testModuleName: String
}