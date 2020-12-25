//
//  String.swift
//  
//
//  Created by 罗树新 on 2020/12/20.
//

import Foundation

public extension String {
    var md5: String {
        guard let data = data(using: .utf8) else {
            return self
        }

        #if swift(>=5.0)
        let message = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            return [UInt8](bytes)
        }
        #else
        let message = data.withUnsafeBytes { bytes in
            return [UInt8](UnsafeBufferPointer(start: bytes, count: data.count))
        }
        #endif

        let MD5Calculator = MD5(message)
        let MD5Data = MD5Calculator.calculate()

        var MD5String = String()
        for c in MD5Data {
            MD5String += String(format: "%02x", c)
        }
        return MD5String
    }
}


public extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start..<end]
    }
    
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        if end < start { return "" }
        return self[start...end]
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex...end]
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        if end < startIndex { return "" }
        return self[startIndex..<end]
    }
}

public extension String {
    
    /// 只有数字
    var isDigits: Bool {
        let notDigits = CharacterSet.decimalDigits.inverted
        return rangeOfCharacter(from: notDigits, options: .literal, range: nil) == nil
    }
    
    /// 只有字母
    var isLetters: Bool {
        let notLetters = CharacterSet.letters.inverted
        return rangeOfCharacter(from: notLetters, options: .literal, range: nil) == nil
    }
    
    /// 字母、数字组成
    var isAlphanumeric: Bool {
        let notAlphanumeric = CharacterSet.decimalDigits.union(.letters).inverted
        return rangeOfCharacter(from: notAlphanumeric, options: .literal, range: nil) == nil
    }
}

public extension String {
    
    var isEmail: Bool {
        regexMatches("^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$")
    }
    
    var isMobileNumber: Bool {
        if isChinaMobile || isChinaUnicom || isChinaTelecom {
            return true
        }
        
        return false
    }
    
    /// 三大运营商号段，同步日期 2020年1月10日
    /// 电信
    var isChinaTelecom: Bool {
        regexMatches("^(?:133|149|153|162|1700|1701|1702|173|177|18[019]|19[0139])\\d{7,8}$")
    }
    
    /// 中国移动
    var isChinaMobile: Bool {
        regexMatches("^134[0-8]\\d{7}$|^(?:13[5-9]|147|15[0-27-9]|178|1703|1705|1706|18[2-478])\\d{7,8}$")
    }
    
    /// 中国联通
    var isChinaUnicom: Bool {
        regexMatches("^(?:13[0-2]|145|15[56]|176|167|1704|1707|1708|1709|171|18[56])\\d{7,8}$")
    }
    
    var isSameMobileNumber: Bool {
        regexMatches("^1[0-9]{10}$")
    }
    
    var isCarNumber: Bool {
        regexMatches("^[\\u4e00-\\u9fa5]{1}[A-Za-z]{1}·?[A-Za-z_0-9]{5}$")
    }
    
    var isUrl: Bool {
        regexMatches("^(https?:/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$")
    }
    
    func regexMatches(_ pattern: String) -> Bool  {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.count))
        return matches.count > 0
    }
}

public extension String {
    
    /// 间隔插入字符
    /// - Parameters:
    ///   - separator: 需要插入的字符
    ///   - n: 间隔数
    ///
    ///         let result = "1234567890123456"
    ///         result.insert(" ", eveny: 4)
    ///         print(result)
    ///
    ///     result值为 1234 5678 9012 3456
    mutating func insert(_ separator: String, eveny n: Int) {
        self = insert(separator, every: n)
    }
    
    /// 间隔插入字符
    /// - Parameters:
    ///   - separator: 需要插入的字符
    ///   - n: 间隔数
    /// - Returns: 插入字符后的字符
    ///
    ///     let result = "1234567890123456".insert(" ", eveny: 4)
    ///     print(result)
    ///
    ///     result值为 1234 5678 9012 3456
    func insert(_ separator: String, every n: Int) -> String {
        var result: String = ""
        let characters = Array(self)
        let strides = stride(from: 0, to: count, by: n)
        strides.forEach {
            result += String(characters[$0..<min($0+n, count)])
            if $0+n < count { result += separator }
        }
        
        return result
    }
}
