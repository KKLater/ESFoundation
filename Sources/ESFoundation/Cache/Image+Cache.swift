//
//  File.swift
//  
//
//  Created by 罗树新 on 2020/12/22.
//

import Foundation

#if !os(macOS)
import UIKit
#else
import AppKit
#endif

public extension Cacheable {
        
    #if !os(macOS)
    
    /// 存储图片
    /// - Parameters:
    ///   - image: 图片
    ///   - key: 缓存键值
    ///   - expires: 过期时间
    /// - Returns: 是否缓存成功
    @discardableResult
    public func save(_ image: UIImage, for key: String, expires: Date? = nil) -> Bool {
        guard let data = image.pngData() else { return false }
        return save(data, for: key, expires: expires)
    }
    
    /// 图片获取
    /// - Parameter key: 缓存键值
    /// - Returns: 查询缓存的图片
    public func image(for key: String) -> UIImage? {
        guard let data = data(for: key), let img = UIImage(data: data) else {
            return nil
        }
        return img
    }
    
    #else
    
    /// 存储图片
    /// - Parameters:
    ///   - image: 图片
    ///   - key: 缓存键值
    ///   - expires: 过期时间
    /// - Returns: 是否缓存成功
    @discardableResult
    public func save(_ image: NSImage, for key: String, expires: Date? = nil) -> Bool {
        guard let data = image.tiffRepresentation else { return false }
        return save(data, for: key, expires: expires)
    }
    
    /// 图片获取
    /// - Parameter key: 缓存键值
    /// - Returns: 查询缓存的图片
    public func image(for key: String) -> NSImage? {
        guard let data = data(for: key), let img = NSImage(data: data) else {
            return nil
        }
        return img
    }
    #endif
}
