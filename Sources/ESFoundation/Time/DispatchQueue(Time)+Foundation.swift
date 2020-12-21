//
//  File.swift
//  
//
//  Created by 罗树新 on 2020/12/21.
//

import Foundation

extension DispatchQueue {
    #if os(OSX)
        @available(OSXApplicationExtension 10.10, *)
        func asyncAfter<Unit>(_ interval: Interval<Unit>, execute item: DispatchWorkItem) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, execute: item)
        }

        @available(OSXApplicationExtension 10.10, *)
        func asyncAfter<Unit>(_ interval: Interval<Unit>, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute block: @escaping () -> Void) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, qos: qos, flags: flags, execute: block)
        }

    #elseif os(iOS) || os(watchOS) || os(tvOS) || os(Linux)
        func asyncAfter<Unit>(_ interval: Interval<Unit>, execute item: DispatchWorkItem) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, execute: item)
        }

        func asyncAfter<Unit>(_ interval: Interval<Unit>, qos: DispatchQoS = .default, flags: DispatchWorkItemFlags = [], execute block: @escaping () -> Void) {
            self.asyncAfter(deadline: .now() + interval.timeInterval, qos: qos, flags: flags, execute: block)
        }
    #endif
}
