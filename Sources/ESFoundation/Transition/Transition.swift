//
//  Transition.swift
//  
//
//  Created by 罗树新 on 2020/12/24.
//

import Foundation

public extension Data {
    var string: String? {
        return String(data: self, encoding: .utf8)
    }
    
    var dictionary: [String: Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [String: Any]
    }
    
    var array: [Any]? {
        return try? JSONSerialization.jsonObject(with: self, options: .mutableContainers) as? [Any]
    }
    
    var urlEncode: String? {
        return string?.urlEncode
    }
    
    var urlDecode: String? {
        return string?.urlDecode
    }
}

public extension Array {
    
    var data: Data? {
       return try? JSONSerialization.data(withJSONObject: self, options: []) as Data
    }
    
    var jsonString: String? {
        guard let data = data else { return nil }
        return data.string
    }
    
    var urlEncode: String? {
        return jsonString?.urlEncode
    }
    
    var urlDecode: String? {
        return jsonString?.urlDecode
    }
}

public extension Dictionary {
    
    var data: Data? {
       return try? JSONSerialization.data(withJSONObject: self, options: []) as Data
    }
    
    var jsonString: String? {
        guard let data = data else { return nil }
        return data.string
    }
    
    var urlEncode: String? {
        return jsonString?.urlEncode
    }
    
    var urlDecode: String? {
        return jsonString?.urlDecode
    }
    
}

public extension String {
    
    var data: Data? {
        return data(using: .utf8)
    }
    
    var dictionary: [String: Any]? {
        guard let data = data else { return nil }
        return data.dictionary
    }
    
    var array: [Any]? {
        guard let data = data else { return nil }
        return data.array
    }
    
    var urlEncode: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    var urlDecode: String? {
        return replacingOccurrences(of: "+", with: " ").removingPercentEncoding
    }
}
