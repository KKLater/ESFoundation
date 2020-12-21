import XCTest
@testable import ESArray

final class ESFoundationArrayTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
//
//        var array = [String]()
//        array.append("a")
//        array.append("b")
//
//        array.remove("c")
//        array.append("a")
//        array.append("c")
//        array.append("b")
//        array.append("a")
//        array.append("b")
//        array.removeFirst("a")
//        array.removeLast("a")
//        array.remove("b")
//        array.append(["a", "b" , "c"])

//        var array = [1, 2, 3, 4, 5]
//        let array1 = [1, 3, 10, 4, 9]
//        array.append(elements: array1) { $0 > 5 }
        
        var array = [1, 2, 3, 4, 3, 2, 1]
        array.removeAll(2)
        print(array)
        
        array = [1, 2, 3, 3, 2, 1]
        array.remove(elements: [1, 5, 3])
        
        array = [1, 2, 2, 3, 4, 3, 9]
//        // 找出所有偶数数据的下标
////        let indexs = array.indexes { $0 % 2 == 0 }
//        let newArray = array.enumerated { (number) -> Int in
//            return number + 10
//        } where: { (number) -> Bool in
//            return number % 2 == 0
//        }
//
//        let newArray1 = array.enumerated { $0 + 10 }
        
        let newArray1 = array.enumerated { $0 % 2 == 0 }
        let newArray2 = array.filter { $0 % 2 == 0 }
        let newArray3 = array.removeDuplicates { "\($0)" }
        let newArray4 = array.filterDuplicates { "\($0)" }

        array.removeDuplicates()
        print(newArray1)
//        let indexes = array.indexes { $0 == "a" }
        

//        array.append(["a", "b", "c"])
//        array.append(where: { (element) -> Bool in
//            return element != "a"
//        }, ["a", "1", "2"])
//
//        array.append(elements: ["1", "2", "a"]) { $0 != "a"}
//        array.remove(elements: ["1", "3"]) { $0 != "3" }
//        array.remove(elements: ["1", "3", "a"])
//        if Date().isInPast {
//
//        }
//        print(Date().timestampString)
//        print(Date().msecTimestampString)

    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
