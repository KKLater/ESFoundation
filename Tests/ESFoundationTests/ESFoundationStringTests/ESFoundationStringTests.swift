import XCTest
@testable import ESString

final class ESFoundationStringTests: XCTestCase {
    func testMd5() {
        let string = "originString"
        let md5String = "9b9403bddba5108bcdb97cab6f79f90e"
        
        print(md5String[10])
        print(md5String[0..<3])
        
        XCTAssertEqual(string.md5, md5String)
    }
    
    func testMobile() {
        print("18612345678 is mobileNumber ==  \("18612345678".isMobileNumber)")
        print("11112345678 is mobileNumber ==  \("11112345678".isMobileNumber)")
        print("111111111 is mobileNumber ==  \("111111111".isMobileNumber)")
        
        print("18612345678 is sameMobileNumber ==  \("18612345678".isSameMobileNumber)")
        print("11112345678 is sameMobileNumber ==  \("11112345678".isSameMobileNumber)")
        print("111111111 is sameMobileNumber ==  \("111111111".isSameMobileNumber)")
    }
    
    func testCarNumber() {
        print("鲁B·660HB is carNumber ==  \("鲁B·660HB".isCarNumber)")
        print("鲁B660HB is carNumber ==  \("鲁B660HB".isCarNumber)")
        print("沪K·R9888 is carNumber ==  \("沪K·R9888".isCarNumber)")        
    }
    
    func testUrl() {
        print("https://cloud.tencent.com/developer/article/1383442 is url ==  \("https://cloud.tencent.com/developer/article/1383442".isUrl)")
        print("https://cloud.tencent.com/developer is url ==  \("https://cloud.tencent.com/developer".isUrl)")
        print("a is url ==  \("a".isUrl)")
        print("www.baidu.com is url ==  \("www.baidu.com".isUrl)")
    }
    
    func testEmail() {
        print("obj@123.com is email ==  \("obj@123.com".isEmail)")
        print("www.baidu.com is email ==  \("www.baidu.com".isEmail)")
    }
    
    static var allTests = [
        ("testMd5", testMd5),
        ("testUrl", testUrl),
        ("testEmail", testEmail),
        ("testMobile", testMobile)
    ]
    
}
