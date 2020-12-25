//
//  CacheModel.swift
//  Cache
//
//  Created by 罗树新 on 2020/12/9.
//

import Foundation
 
class CacheModel: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(data, forKey: "data")
        if let e = expires {
            coder.encode(e, forKey: "expires")
        }
    }
    
    required init?(coder: NSCoder) {
        guard let data = coder.decodeObject(forKey: "data") as? Data else { return nil }
        self.data = data
        self.expires = coder.decodeObject(forKey: "expires") as? Date
    }
    
    var data: Data
    var expires: Date?
    init(data: Data, expires: Date?) {
        self.data = data
        self.expires = expires
    }
}
