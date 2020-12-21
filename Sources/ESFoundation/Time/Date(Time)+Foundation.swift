//
//  File.swift
//  
//
//  Created by 罗树新 on 2020/12/21.
//

import Foundation

extension Date {
    
    public func addingTimeInterval<Unit>(_ interval: Interval<Unit>) -> Date {
        return addingTimeInterval(interval.timeInterval)
    }
    
    public static func + <Unit>(lhs: Date, rhs: Interval<Unit>) -> Date {
        return lhs.addingTimeInterval(rhs)
    }
    
    public static func - <Unit>(lhs: Date, rhs: Interval<Unit>) -> Date {
        return lhs.addingTimeInterval(-rhs)
    }
    
    public static func += <Unit>(lhs: inout Date, rhs: Interval<Unit>) {
        lhs = lhs + rhs
    }
    
    public static func -= <Unit>(lhs: inout Date, rhs: Interval<Unit>) {
        lhs = lhs - rhs
    }
    
}
