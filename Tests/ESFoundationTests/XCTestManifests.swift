import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(ESFoundationTests.allTests),
        testCase(ESFoundationStringTests.allTests),
        testCase(ESFoundationDateFormatterTests.allTests),
    ]

    
}
#endif
