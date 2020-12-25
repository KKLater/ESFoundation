import XCTest

import ESFoundationArrayTests
import ESFoundationStringTests
import ESFoundationDateFormatterTests

var tests = [XCTestCaseEntry]()
tests += ESFoundationArrayTests.allTests()
tests += ESFoundationStringTests.allTests()
tests += ESFoundationDateFormatterTests.allTests()
XCTMain(tests)
