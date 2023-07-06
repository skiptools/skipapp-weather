import XCTest
@testable import AppUI
import AppModel

class AppUITests: XCTestCase {
    func testAppUI() throws {
        let thing = Thing(string: "ABC", number: 123.4)
        XCTAssertEqual(123.4, thing.number)
    }
}
