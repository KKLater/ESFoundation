import XCTest
@testable import ESString

final class ESFoundationStringTests: XCTestCase {
    func testMd5() {
        let string = "originString"
        let md5String = "9b9403bddba5108bcdb97cab6f79f90e"
        XCTAssertEqual(string.md5, md5String)
    }
    
    static var allTests = [
        ("testMd5", testMd5),
    ]
}
