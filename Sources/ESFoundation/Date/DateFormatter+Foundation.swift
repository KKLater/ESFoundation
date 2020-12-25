//
//  DateFormat.swift
//  
//
//  Created by 罗树新 on 2020/12/21.
//



import Foundation
import ESCache

/// DateFormatter 可以依据的 format 格式化字符 和 位置信息进行创建；
/// 也可以只依据 format 格式化字符串并以系统current locale 做创建
/// 除了 format 格式化字符串，也可以依据传入的西戎提供 Style 方案进行创建；
/// 在创建之前，会根据传入信息，format、localeIdentifier 或者 dateStylr、timeStyle、localIdentifier 生成缓存的key
/// 在本地缓存中，依据生成的key查找之前的缓存实例，避免多次创建，消耗性能
/// 如果缓存中没有查找到，则会生成新的 DateFomatter，并缓存
/// 缓存条数限制为 10 条
/// 缓存为自动释放缓存，在iOS 或者 tvOS 中，有内存警告时，会自动清理
public extension DateFormatter {
    
 
    /// dateFormatter 缓存池
    private static var cache: ESCache.AutoPurgeCache<NSString, DateFormatter>?

    /// 创建或从缓存读取 dateFormatter
    /// - Parameters:
    ///   - dateFormat: 日期格式化方案
    ///   - locale: 位置信息
    /// - Returns: dateFormatter
    static func dateFormatter(with dateFormat: String, locale: Locale? = Locale.current) -> DateFormatter {
        let key = cacheKey(with: dateFormat, localeIdentifier: locale?.identifier)
        if let formatter = dateFormatter(for: key) {
            return formatter
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = locale
        cache(formatter, for: key)
        return formatter
    }
    
    /// 创建或从缓存读取 dateFormatter
    /// - Parameters:
    ///   - dateStyle: 日期格式
    ///   - timeStyle: 时间格式
    ///   - localeIdentifier: 位置信息标识
    /// - Returns: dateFormatter
    static func dateFormatter(with dateStyle: Style, timeStyle: Style, locale: Locale? = Locale.current) -> DateFormatter {
        
        let key = cacheKey(with: dateStyle, timeStyle: timeStyle, localeIdentifier: locale?.identifier)
        if let dateFormatter = dateFormatter(for: key) {
            return dateFormatter
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = locale
        cache(formatter, for: key)
        return formatter
    }
    
}

private extension DateFormatter {
    
    static func cache(_ format: DateFormatter, for key: String) {
        if cache == nil {
            cache = ESCache.AutoPurgeCache<NSString, DateFormatter>()
            cache?.countLimit = 10
        }
        cache?.setObject(format, forKey: key as NSString)
    }
    
    static func dateFormatter(for key: String) -> DateFormatter? {
        return cache?.object(forKey: key as NSString) as? DateFormatter
    }
    
    static func cacheKey(with dateStyle: Style, timeStyle: Style, localeIdentifier: String? = nil) -> String {
        var key = ""
        key += "\(dateStyle)"
        key += "\(timeStyle)"
        if let identifier = localeIdentifier {
            key += identifier
        } else {
            key += Locale.current.identifier
        }
        return key
    }
    
    static func cacheKey(with dateFormat: String, localeIdentifier: String? = nil) -> String {
        var key = dateFormat
        if let identifier = localeIdentifier {
            key += identifier
        } else {
            key += Locale.current.identifier
        }
        return key
    }
}
