import XCTest
@testable import AppModel

class AppModelTests: XCTestCase {
    func testAppModel() throws {
        let thing = Thing(string: "ABC", number: 123.456)
        XCTAssertEqual(123.456, thing.number)
    }
}
