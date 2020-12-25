//
//  File.swift
//  
//
//  Created by 罗树新 on 2020/12/20.
//

import Foundation

extension DispatchQueue {
    
    private static var _onceTracker = [String]()
    
    /// 执行一次操作
    /// - Parameters:
    ///   - token: 执行一次操作的键值
    ///   - block: 执行操作
    /// - Returns: 无返回值
    ///
    /// once 执行，首先  objc_sync_enter、objc_sync_exit 锁的操作，保证线程操作安全
    /// 内部检查 token 对应的操作是否执行过，即是否存储过 token
    /// 如果存储过 token，即之前执行过，不再执行；
    /// 如果没有存储过，则之前没有执行过操作，将token 存储标识执行过操作，之后执行一次操作
    public class func once(token: String, block: () -> ()) {
        objc_sync_enter(self)
        defer {
            objc_sync_exit(self)
        }
        if _onceTracker.contains(token) {
            return
        }
        _onceTracker.append(token)
        block()
    }
}
