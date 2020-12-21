import XCTest

import ESFoundationArrayTests
import ESFoundationStringTests

var tests = [XCTestCaseEntry]()
tests += ESFoundationArrayTests.allTests()
tests += ESFoundationStringTests.allTests()
XCTMain(tests)
