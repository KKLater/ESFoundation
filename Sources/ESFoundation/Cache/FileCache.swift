//
//  FileCache.swift
//  ESCache
//
//  Created by 罗树新 on 2020/12/9.
//
//  Copyright (c) 2020 Later<lshxin89@126.com>
//

import Foundation
#if !os(macOS)
import UIKit
#endif
import ESString

public class FileCache {

    public enum Directory {
        case library
        case cache
        case document
        case downloads
        case temp
  
        public static func url(for directory: Directory) -> URL {
            switch directory {
            case .library: return Directory.libraryDirectoryURL
            case .document: return Directory.documentsDirectoryURL
            case .cache: return Directory.cachesDirectoryURL
            case .downloads: return Directory.downloadsDirectoryURL
            case .temp:
                if #available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *) {
                    return Directory.tempDirectoryURL
                }
                return Directory.cachesDirectoryURL
            }
        }
        
        fileprivate static let libraryDirectoryURL : URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.libraryDirectory, in: .userDomainMask).first!
        
        fileprivate static let documentsDirectoryURL : URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        fileprivate static let cachesDirectoryURL: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.cachesDirectory, in: .userDomainMask).first!
        
        fileprivate static let downloadsDirectoryURL: URL = FileManager.default.urls(for: FileManager.SearchPathDirectory.downloadsDirectory, in: .userDomainMask).first!
        
        @available(iOS 10.0, macOS 10.12, tvOS 10.0, watchOS 3.0, *)
        fileprivate static let tempDirectoryURL: URL = FileManager.default.temporaryDirectory
    }
    
    public static let `default` = FileCache(directory: .cache)
    
    public static let cache = FileCache.default
    
    public static let document = FileCache(directory: .document)
    
    public static let download = FileCache(directory: .downloads)
    
    public static let libraby = FileCache(directory: .library)
    
    public static let temp = FileCache(directory: .temp)
    
    fileprivate static let kDefaultDiskCacheMaxCacheInterval: TimeInterval  = 60 * 60 * 24 * 7; // 1 周
    
    public var maxCacheInterval = FileCache.kDefaultDiskCacheMaxCacheInterval

    public var maxCacheSize: Double?

    public var name: String
    
    fileprivate var queue: DispatchQueue
    
    fileprivate var autoCache: AutoPurgeCache<NSString, CacheModel>
    
    fileprivate var directoryUrl: URL
    
    fileprivate let lock = NSLock()
    
    init(name: String = "Cache", directory: Directory) {
        self.name = name
        self.queue = DispatchQueue(label: name, qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit)
        self.autoCache = AutoPurgeCache<NSString, CacheModel>()
        self.autoCache.name = name;
        let url = Directory.url(for: directory)
        self.directoryUrl = url.appendingPathComponent(name)
        try? FileManager.default.createDirectory(at: self.directoryUrl, withIntermediateDirectories: true, attributes: nil)
        #if os(iOS) || os(tvOS)
        _addNotificationObserver()
        #endif
    }
        
    fileprivate func url(for key: String) -> URL {
        return directoryUrl.appendingPathComponent(key.md5, isDirectory: false)
    }
    
    @objc public func cleanMemoryCache() {
        lock.lock()
        autoCache.removeAllObjects()
        lock.unlock()
    }
    
    public func currentFileSize() -> UInt64 {
        var size: UInt64 = 0
        if let enumtor = FileManager.default.enumerator(atPath: directoryUrl.path) {
            var file = enumtor.nextObject()
            while let f = file as? String {
                let path = directoryUrl.path.appending(f)
                let att: NSDictionary = try! FileManager.default.attributesOfItem(atPath: path) as NSDictionary
                size = size + att.fileSize()
                file = enumtor.nextObject()
            }
        }
        return size
    }

    /// 清理磁盘存储
    /// - Parameter completion: 清理回调
    public func cleanDist(_ completion:((Bool)->())? = nil) {
        queue.async {
            do{
                let resourceKeys = [URLResourceKey.isDirectoryKey, URLResourceKey.contentModificationDateKey, URLResourceKey.totalFileAllocatedSizeKey]
                let directoryEnumerator: FileManager.DirectoryEnumerator? = FileManager.default.enumerator(at: self.directoryUrl, includingPropertiesForKeys: resourceKeys, options: .skipsHiddenFiles)
                let expiredDate = Date.init(timeIntervalSinceNow: -self.maxCacheInterval)
                var files: [URL:URLResourceValues] = [URL:URLResourceValues]()
                var urlsForDel:[URL] = []
                var currentCacheSize: Double = 0.0
                let elementResourceKeys:Set<URLResourceKey> = [URLResourceKey.isDirectoryKey, URLResourceKey.contentModificationDateKey, URLResourceKey.totalFileAllocatedSizeKey]
                while let element = directoryEnumerator?.nextObject() as? URL {
                    
                    let resources: URLResourceValues = try element.resourceValues(forKeys:elementResourceKeys)
                    if resources.isDirectory == true {
                        return
                    }
                    if resources.isRegularFile == true {
                        let modificationDate: Date? = directoryEnumerator?.fileAttributes?[FileAttributeKey.modificationDate] as? Date
                        if let md = modificationDate, md > expiredDate {
                            urlsForDel.append(element)
                            continue
                        }
                        let totalAllocatedSize = resources.allValues[URLResourceKey.totalFileAllocatedSizeKey]
                        currentCacheSize += totalAllocatedSize as! Double
                    }
                    
                    
                    files[element] = resources
                }
                
                for url in urlsForDel {
                    try FileManager.default.removeItem(at: url)
                }
                
                if let maxCacheSize = self.maxCacheSize, maxCacheSize > 0, currentCacheSize > maxCacheSize {
                    let desiredCacheSize: Double = maxCacheSize / 2.0
                    
                    let sorted = files.sorted { (arg0, arg1) -> Bool in
                        let (_, value1) = arg0
                        let (_, value2) = arg1
                        
                        return (value1.allValues[URLResourceKey.contentModificationDateKey] as! Date) > (value2.allValues[URLResourceKey.contentModificationDateKey] as! Date)
                    }
                    
                    for arg0 in sorted {
                        let (url, resources) = arg0
                        try FileManager.default.removeItem(at: url)
                        let totalAllocatedSize = resources.allValues[URLResourceKey.totalFileAllocatedSizeKey]
                        currentCacheSize -= totalAllocatedSize as! Double
                        if currentCacheSize < desiredCacheSize {break}
                    }
                }
                
            } catch {
                completion?(false)
            }
            
            completion?(true)
        }
    }
    
    #if os(iOS) || os(tvOS)
    /// App 退到后台时候，清理磁盘存储
    @objc func cleanDickBackground() {
        var bgTask:UIBackgroundTaskIdentifier?
        let application: UIApplication = UIApplication.shared
        bgTask = application.beginBackgroundTask(expirationHandler: {
            if var bt = bgTask {
                application.endBackgroundTask(bt)
                bt = UIBackgroundTaskIdentifier.invalid
            }
           
        })
           
        
        cleanDist { (err) in
            if var bt = bgTask {
                application.endBackgroundTask(bt)
                bt = UIBackgroundTaskIdentifier.invalid
            }
        }
    }
    
    @objc func _self_cleanDisk() {
        cleanDist()
    }
    
    //MARK: Private
    private func _addNotificationObserver() {
        _removeNotificationObserver()
        NotificationCenter.default.addObserver(self, selector: #selector(cleanMemoryCache), name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(_self_cleanDisk), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cleanDickBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    private func _removeNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didReceiveMemoryWarningNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    #endif
}

/// save
extension FileCache: Cacheable {
    
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
        lock.unlock()
        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            guard let data = try? NSKeyedArchiver.archivedData(withRootObject: cacheModel, requiringSecureCoding: true) else {
                return false
            }
            try? data.write(to: url(for: key))
            return exists(for: key)
        } else {
            NSKeyedArchiver.archiveRootObject(cacheModel, toFile: url(for: key).path)
            return exists(for: key)
        }
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
        if cacheModel == nil {
            queue.sync { [unowned self] in
                cacheModel = NSKeyedUnarchiver.unarchiveObject(withFile: url(for: key).path) as? CacheModel
            }
        }
        if let expires = cacheModel?.expires, expires.timeIntervalSinceNow < 0 {
            // 移除
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
      
        if let cacheModel: CacheModel = autoCache.object(forKey: key as NSString) as? CacheModel {
            if let expires = cacheModel.expires, expires.timeIntervalSinceNow < 0 {
                removeObject(for: key)
                return false
            }
            return true
        }
        
        if data(for: key) != nil {
            return true
        }
        return false
    }
    
    /// 清理掉缓存数据
    /// - Parameter key: 缓存键值
    @discardableResult
    public func removeObject(for key: String) -> Bool {
        lock.lock()
        autoCache.removeObject(forKey: key as NSString)
        lock.unlock()
        queue.sync { [unowned self] in
            try? FileManager.default.removeItem(at: url(for: key))
        }
        if exists(for: key) == true {
            return false
        }
        return true
    }
    
    /// 清理掉所有缓存，并重建缓存
    public func removeAllObjects() {
        lock.lock()
        autoCache.removeAllObjects()
        lock.unlock()
        queue.sync {
            try? FileManager.default.removeItem(at: self.directoryUrl)
            try? FileManager.default.createDirectory(at: self.directoryUrl, withIntermediateDirectories: true, attributes: nil)
        }
    }
}
