//
//  MemoryCache.swift
//  ESCache
//
//  Created by 罗树新 on 2020/12/9.
//

import Foundation

public class MemoryCache {
    static let `default` = MemoryCache()
    var name: String
    var cleanInterval: TimeInterval = 120
    var keys = Set<String>()
    fileprivate var autoCache: AutoPurgeCache<NSString, CacheModel>
    fileprivate let lock = NSLock()
    fileprivate var cleanTimer: Timer? = nil
    init(name: String = "MemoryCache") {
        self.name = name
        self.autoCache = AutoPurgeCache<NSString, CacheModel>()
        self.autoCache.name = name
        
        if #available(iOS 10.0, macOS 10.13, tvOS 10.0, watchOS 3.0, *) {
        cleanTimer = .scheduledTimer(withTimeInterval: self.cleanInterval, repeats: true, block: { [weak self] (timer) in
            guard let self = self else { return }
            self.removeExpired()
        })
        } else {
            cleanTimer = .scheduledTimer(timeInterval: self.cleanInterval, target: self, selector: #selector(removeExpired), userInfo: nil, repeats: true)
        }
    }
    
    @objc
    func removeExpired() {
        lock.lock()
        defer { lock.unlock() }
        for key in keys {
            let nsKey = key as NSString
            guard let object = autoCache.object(forKey: nsKey) as? CacheModel else {
                keys.remove(key)
                continue
            }
            if let expires = object.expires, expires.timeIntervalSinceNow < 0 {
                autoCache.removeObject(forKey: nsKey)
                keys.remove(key)
            }
        }
    }
}
extension MemoryCache: Cacheable {

    /// 缓存 Data 数据
    /// - Parameters:
    ///   - data: 缓存数据
    ///   - key: 缓存键值
    ///   - expires: 过期时间
    @discardableResult
    public func save(_ data: Data, for key: String, expires: Date? = nil) -> Bool {
        let cacheModel = CacheModel(data: data, expires: expires)
        lock.lock()
        autoCache.setObject(cacheModel, forKey: key as NSString)
        keys.insert(key)
        lock.unlock()
        return exists(for: key)
    }
   
    /// 查询缓存数据
    /// - Parameter key: 缓存键值
    ///
    /// 如果根据键值查询到数据，但是数据设置过期时间并已经过期，则会清理到缓存数据，查询为空
    /// 如果根据键值查询到数据，数据没有设置过期时间或者设置过期时间有效期内，则查询成功
    public func data(for key: String) -> Data? {
        lock.lock()
        var cacheModel: CacheModel? = autoCache.object(forKey: key as NSString) as? CacheModel
        lock.unlock()
        if let expires = cacheModel?.expires, expires.timeIntervalSinceNow < 0 {
            removeObject(for: key)
            cacheModel = nil
        }
    
        return cacheModel?.data
    }
    
    /// 是否已经缓存了数据
    /// - Parameter key: 缓存键值
    ///
    /// 如果数据已经缓存，并且设置了过期时间，则会清理掉缓存缓存无效
    /// 如果数据已经缓存，没有设置过期时间，则缓存有效
    public func exists(for key: String) -> Bool {
        lock.lock()
        guard let cacheModel: CacheModel = autoCache.object(forKey: key as NSString) as? CacheModel else {
            keys.remove(key)
            lock.unlock()
            return false
        }
        lock.unlock()
        if  let expires = cacheModel.expires, expires.timeIntervalSinceNow < 0 {
            removeObject(for: key)
            return false
        }
        return true
    }
    
    /// 清理掉缓存数据
    /// - Parameter key: 缓存键值
    @discardableResult
    public func removeObject(for key: String) -> Bool {
        lock.lock()
        autoCache.removeObject(forKey: key as NSString)
        keys.remove(key)
        lock.unlock()
        return exists(for: key)
    }
    
    /// 清理掉所有缓存，并重建缓存
    public func removeAllObjects() {
        lock.lock()
        autoCache.removeAllObjects()
        keys.removeAll()
        lock.unlock()
    }
}
