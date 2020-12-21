//
//  DateFormat.swift
//  
//
//  Created by 罗树新 on 2020/12/21.
//

import Foundation

public extension DateFormatter {
    
    static func dateFormatter(with dateFormat: String, local: Locale? = Locale.current) -> DateFormatter {
        let key = cacheKey(with: dateFormat, localeIdentifier: local?.identifier)
        if let formatter = DateFormatterProvider.default.dateFormatter(for: key) {
            return formatter
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = local
        DateFormatterProvider.default.cache(formatter, for: key)
        return formatter
    }
    
    static func dateFormatter(with dateFormat: String, localeIdentifier: String? = Locale.current.identifier) -> DateFormatter {
        
        var local: Locale
        if let localeIdentifier = localeIdentifier {
            local = Locale(identifier: localeIdentifier)
        } else {
            local = Locale.current
        }
        let key = cacheKey(with: dateFormat, localeIdentifier: local.identifier)

        if let formatter = DateFormatterProvider.default.dateFormatter(for: key) {
            return formatter
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = local
        DateFormatterProvider.default.cache(formatter, for: key)
        return formatter
    }
    
    static func dateFormatter(with dateStyle: Style, timeStyle: Style, identifier: String? = Locale.current.identifier) -> DateFormatter {
        
        let key = cacheKey(with: dateStyle, timeStyle: timeStyle, localIdentifier: identifier)
        if let dateFormatter = DateFormatterProvider.default.dateFormatter(for: key) {
            return dateFormatter
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        if let identifier = identifier {
            formatter.locale = Locale(identifier: identifier)
        } else {
            formatter.locale = Locale.current
        }
        DateFormatterProvider.default.cache(formatter, for: key)
        return formatter
    }
    
    static func dateFormatter(with dateStyle: Style, timeStyle: Style, locale: Locale? = Locale.current) -> DateFormatter {
        
        let key = cacheKey(with: dateStyle, timeStyle: timeStyle, localIdentifier: locale?.identifier)
        if let dateFormatter = DateFormatterProvider.default.dateFormatter(for: key) {
            return dateFormatter
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = dateStyle
        formatter.timeStyle = timeStyle
        formatter.locale = locale
        DateFormatterProvider.default.cache(formatter, for: key)
        return formatter
    }
    
    private static func cacheKey(with dateStyle: Style, timeStyle: Style, localIdentifier: String? = nil) -> String {
        var key = ""
        key += "\(dateStyle)"
        key += "\(timeStyle)"
        if let identifier = localIdentifier {
            key += identifier
        } else {
            key += Locale.current.identifier
        }
        return key
    }
    
    private static func cacheKey(with dateFormat: String, localeIdentifier: String? = nil) -> String {
        var key = dateFormat
        if let identifier = localeIdentifier {
            key += identifier
        } else {
            key += Locale.current.identifier
        }
        return key
    }
    
}

private struct DateFormatterProvider {
    static var `default` = DateFormatterProvider()
    
    var cache: NSCache<NSString, DateFormatter>?
    
    mutating func cache(_ format: DateFormatter, for key: String) {
        if cache == nil {
            cache = NSCache<NSString, DateFormatter>()
            cache?.countLimit = 10
        }
        cache?.setObject(format, forKey: key as NSString)
        
    }
    
    func dateFormatter(for key: String) -> DateFormatter? {
        return cache?.object(forKey: key as NSString)
    }
}
