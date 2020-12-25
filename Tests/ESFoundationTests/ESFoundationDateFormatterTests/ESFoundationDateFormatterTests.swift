
import XCTest
@testable import ESDate


final class ESFoundationDateFormatterTests: XCTestCase {
    func testExample() {
        let dateFormat = DateFormatter.dateFormatter(with: "hh-MM-ss")
        let date = Date()
        let formatDate = dateFormat.string(from: date)
        print(formatDate)

        let dateFormatter2 = DateFormatter.dateFormatter(with: "hh-MM-ss")
        print(dateFormatter2)
//
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
