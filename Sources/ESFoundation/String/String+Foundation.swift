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
