import XCTest
@testable import RazeMindCore

final class RazeMindCoreTests: XCTestCase {
    func testVersion() throws {
        XCTAssertEqual(RazeMindCore().version, "1.0")
    }
}
