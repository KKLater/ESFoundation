//
//  Date.swift
//  
//
//  Created by 罗树新 on 2020/12/20.
//

import Foundation

public extension Date {
    var timestamp: TimeInterval {
        let timeIntervalSince1970 = self.timeIntervalSince1970
        return timeIntervalSince1970
    }
    
    var timestampString: String {
        return String(self.timestamp)
    }
    
    var msecTimestamp: TimeInterval {
        return self.timestamp * 1000
    }
    
    var msecTimestampString: String {
        return String(self.msecTimestamp)
    }
    
    var isInToday: Bool {
        return DateDecorator.default.calendar.isDateInToday(self)
    }
    
    var isInTomorrow: Bool {
        DateDecorator.default.calendar.isDateInTomorrow(self)
    }
    
    var isInYesterDay: Bool {
        DateDecorator.default.calendar.isDateInYesterday(self)
    }
    
    var isInThisWeek: Bool {
        return isInSameWeek(Date())
    }
    
    var isInNextWeek: Bool {
        guard let numberOfDaysInWeek = numberOfDaysInWeek else { return false }
        guard let nextWeek = dateFromNow(numberOfDaysInWeek) else { return false }
        return isInSameWeek(nextWeek)
    }
    
    var isInLastWeek: Bool {
        guard let numberOfDaysInWeek = numberOfDaysInWeek else { return false }
        guard let nextWeek = dateBeforNow(numberOfDaysInWeek) else { return false }
        return isInSameWeek(nextWeek)
    }
    
    var isInThisMonth: Bool {
        isInSameMonth(Date())
    }
    
    var isInThisYear: Bool {
        isInSameYear(Date())
    }
    
    var isInNextYear: Bool {
        guard let date = Date().adding(year: 1) else { return false }
        return isInSameYear(date)
    }
    
    var isInLastYear: Bool {
        guard let date = Date().substracting(year: 1) else { return false }
        return isInSameYear(date)
    }
    
    var isInPast: Bool {
        return self < Date()
    }
    
    var isInFuture: Bool {
        return self > Date()
    }
    
    var isInWeekend: Bool {
        DateDecorator.default.calendar.isDateInWeekend(self)
    }
    
    var hour: Int {
        DateDecorator.default.calendar.component(.hour, from: self)
    }
    
    var minute: Int {
        DateDecorator.default.calendar.component(.minute, from: self)
    }
    
    var seconds: Int {
        DateDecorator.default.calendar.component(.second, from: self)
    }
    
    var day: Int {
        DateDecorator.default.calendar.component(.day, from: self)
    }
    
    var month: Int {
        DateDecorator.default.calendar.component(.month, from: self)
    }
    
    var week: Int {
        DateDecorator.default.calendar.component(.weekOfMonth, from: self)
    }
    
    var weekday: Int {
        DateDecorator.default.calendar.component(.weekday, from: self)
    }
    
    var dateAtStartOfDay: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var components = calendar.dateComponents(flags, from: self)
        components.hour = 0
        components.minute = 0
        components.hour = 0
        components.timeZone = calendar.timeZone
        return calendar.date(from: components)
    }
    
    var dateAtEndOfDay: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        var components = calendar.dateComponents(flags, from: self)
        components.hour = 23
        components.minute = 59
        components.hour = 59
        components.timeZone = calendar.timeZone
        return calendar.date(from: components)
    }
    
    var dateAtStartOfWeek: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.weekday, .era, .year, .month, .day]
        var components = calendar.dateComponents(flags, from: self)
        guard let numberOfDaysInWeek = numberOfDaysInWeek else { return nil }
        guard  let day = components.day else { return nil }
        guard let weekday = components.weekday else { return nil }

        let firstWeekday = calendar.firstWeekday
        if firstWeekday > weekday {
            let countDays = numberOfDaysInWeek + (weekday - firstWeekday)
            components.day =  day - countDays
        } else {
            let countDays = weekday - firstWeekday
            components.day =  day - countDays
        }
        return calendar.date(from: components)
    }
    
    var dateAtEndOfWeek: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.weekday, .era, .year, .month, .day]
        var components = calendar.dateComponents(flags, from: self)
        guard let numberOfDaysInWeek = numberOfDaysInWeek else { return nil }
        guard  let day = components.day else { return nil }
        guard let weekday = components.weekday else { return nil }
        components.day = numberOfDaysInWeek - weekday + day
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)
    }
    
    var dateAtStartOfMonth: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.era, .year, .month, .day]
        var components = calendar.dateComponents(flags, from: self)
        let monthRange = calendar.range(of: .day, in: .month, for: self)
        components.day = monthRange?.startIndex
 
        return calendar.date(from: components)
    }
    
    var dateAtEndOfMonth: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.era, .year, .month, .day]
        var components = calendar.dateComponents(flags, from: self)
        let monthRange = calendar.range(of: .day, in: .month, for: self)
        components.day = monthRange?.count
        components.hour = 23
        components.minute = 59
        components.second = 59
        return calendar.date(from: components)
    }
    
    var dateAtStarOfYear: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.era, .year, .month, .day]
        var components = calendar.dateComponents(flags, from: self)
        let monthRange = calendar.range(of: .month, in: .year, for: self)
        let dayRange = calendar.range(of: .day, in: .month, for: self)
        components.day = dayRange?.startIndex
        components.month = monthRange?.startIndex
      
        return calendar.date(from: components)
    }
    
    var dateAtEndOfYear: Date? {
        let calendar = DateDecorator.default.calendar
        let flags: Set<Calendar.Component> = [.era, .year, .month, .day]
        var components = calendar.dateComponents(flags, from: self)
        let monthRange = calendar.range(of: .month, in: .year, for: self)
        components.month = monthRange?.count

        guard let endMonthOfYear = calendar.date(from: components) else { return nil }

        let dayRange = calendar.range(of: .day, in: .month, for: endMonthOfYear)
        components.day = dayRange?.count
        components.hour = 23
        components.minute = 59
        components.second = 59
 
        return calendar.date(from: components)
    }

    func dateFromNow(_ days: Int) -> Date? {
        return adding(day: days)
    }
    func dateBeforNow(_ days: Int) -> Date? {
        return substracting(day: days)
    }
    
    func isInSameWeek(_ date: Date) -> Bool {
        let calendar = DateDecorator.default.calendar
        
        let leftWeekDay = weekday + ((weekday < calendar.firstWeekday) ? 7 : 0)
        guard let leftDate = substracting(day: leftWeekDay) else { return false }
        
        let rightWeekDay = date.weekday + ((date.weekday < calendar.firstWeekday) ? 7 : 0)
        guard  let rightDate = date.substracting(day: rightWeekDay)  else { return false }
        
        return leftDate.isEqual(rightDate, ignoreTime: true)
    }
    
    func isInSameMonth(_ date: Date) -> Bool {
        let dateAtStartSelfMonth = dateAtStartOfMonth?.dateAtStartOfDay
        let dateAtStartArgs = date.dateAtStartOfMonth?.dateAtStartOfDay
        return dateAtStartSelfMonth == dateAtStartArgs
    }
    
    func isInSameYear(_ date: Date) -> Bool {
        let dateAtStartSelf = dateAtStarOfYear?.dateAtStartOfDay
        let dateAtStartArgs = date.dateAtStarOfYear?.dateAtStartOfDay
        return dateAtStartSelf == dateAtStartArgs
    }
    
    static func < (date1: Date, date2: Date) -> Bool {
        return date1.compare(date2) == .orderedAscending
    }
    
    static func <= (date1: Date, date2: Date) -> Bool {
        let result = date1.compare(date2)
        return result == .orderedAscending || result == .orderedSame
    }
    
    static func > (date1: Date, date2: Date) -> Bool {
        return date1.compare(date2) == .orderedDescending
    }
    
    static func >= (date1: Date, date2: Date) -> Bool {
        let result = date1.compare(date2)
        return result == .orderedDescending || result == .orderedSame
    }
    
    func isEqual(_ date: Date, ignoreTime: Bool? = false) -> Bool {
        let calendar = DateDecorator.default.calendar
        if ignoreTime == true {
            let flags: Set<Calendar.Component> = [.era, .year, .month, .day]
            let components1 = calendar.dateComponents(flags, from: self)
            let components2 = calendar.dateComponents(flags, from: date)
            return components1.era == components2.era && components1.year == components2.year && components1.month == components2.month && components1.day == components2.day
        }
        
        return self == date
        
    }
    
    func adding(year: Int? = 0, month: Int? = 0, day: Int? = 0, hour: Int? = 0, minute: Int? = 0, second: Int? = 0 ) -> Date? {
        if year == 0 && month == 0 && day == 0 && hour == 0 && minute == 0 && second == 0 {
            return self
        }
        
        let components = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
        return DateDecorator.default.calendar.date(byAdding: components, to: self)
    }
    
    func substracting(year: Int? = 0, month: Int? = 0, day: Int? = 0, hour: Int? = 0, minute: Int? = 0, second: Int? = 0 ) -> Date? {
        if year == 0 && month == 0 && day == 0 && hour == 0 && minute == 0 && second == 0 {
            return self
        }
        
        let components = DateComponents(year: -(year ?? 0), month: -(month ?? 0), day: -(day ?? 0), hour: -(hour ?? 0), minute: -(minute ?? 0), second: -(second ?? 0))
        return DateDecorator.default.calendar.date(byAdding: components, to: self)
    }
    
    
    
    var numberOfDaysInWeek: Int? {
        return DateDecorator.default.calendar.maximumRange(of: .weekday)?.count
    }
    
    /// .era 、.year、.month、.day、.hour、.minute、.second
    func components(after date: Date) -> DateComponents {
        let flags: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second]
        return DateDecorator.default.calendar.dateComponents(flags, from: date, to: self)
    }
    
    /// .era 、.year、.month、.day、.hour、.minute、.second
    func components(befor date: Date) -> DateComponents {
        let flags: Set<Calendar.Component> = [.era, .year, .month, .day, .hour, .minute, .second]
        return DateDecorator.default.calendar.dateComponents(flags, from: self, to: date)
    }
    
}

public struct DateDecorator {
    static var `default` = DateDecorator()
    
    var calendar: Calendar = Calendar.current {
        didSet {
            if identifier != calendar.identifier {
                identifier = calendar.identifier
            }
        }
    }
    
    fileprivate var identifier: Calendar.Identifier = Calendar.current.identifier {
        didSet {
            if identifier != calendar.identifier {
                calendar = Calendar(identifier: identifier)
            }
        }
    }
}
