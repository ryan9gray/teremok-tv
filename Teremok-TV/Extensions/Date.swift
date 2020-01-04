
import Foundation
import UIKit

extension Date {
    
    static func dateString(from string: String) throws -> String  {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        if let convertedDate = outputFormatter.date(from: string) {
            return convertedDate.longDateAndTime
        } else {
            throw DateError.parseException
        }
    }
    
    static func dateAndTime(from string: String) throws -> Date {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        if let convertedDate = outputFormatter.date(from: string) {
            return convertedDate
        } else {
            throw DateError.parseException
        }
    }

    var startOfDay: Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        return calendar.startOfDay(for: self)
    }
    
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
    var ageString: String {
        let a =  self.age
        
        var years = "\(a) "
        switch a {
        case 1:
            years.append("год")
        case 2...4:
            years.append("года")
        default:
            years.append("лет")
        }
        return years
    }

    var isToday: Bool {
        return self.startOfDay == Date().startOfDay
    }
    
    var isYesterday: Bool {
        return self.startOfDay == Date().dateByAddingDays(-1).startOfDay
    }
    
    var weekDay: String {
        let weekDayNumber: Int = Calendar.current.component(.weekday, from: self)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        let day: String = formatter.weekdaySymbols[weekDayNumber - 1]
        return day
    }
    
    var shortWeekDay: String {
        let weekDayNumber: Int = Calendar.current.component(.weekday, from: self)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        return formatter.shortWeekdaySymbols[weekDayNumber - 1]
    }
    
    var standaloneMonth: String {
        let monthNumber: Int = Calendar.current.component(.month, from: self)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        return formatter.standaloneMonthSymbols[monthNumber - 1]
    }
    
    var shortMonth: String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "MMM"
        return outputFormatter.string(from: self)
    }

    var shortMonthNominativeCase: String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "LLL"
        return outputFormatter.string(from: self)
    }

    var minutes: Int {
        return Calendar.current.component(.minute, from: self)
    }

    var shortDateString: String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "dd.MM.yyyy"
        return outputFormatter.string(from: self)
    }
    
    var timeString: String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "HH:mm"
        return outputFormatter.string(from: self)
    }
    
    var longDateAndTime: String {
        let outputFormatter = DateFormatter()
        outputFormatter.timeZone = TimeZone.current
        outputFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return outputFormatter.string(from: self)
    }
    
    var short2DateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru")
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: self)
    }
    
    func dateByAddingDays(_ days: Int) -> Date {
        return dateByAdding(component: .day, value: days)
    }
	func dateByAddingHours(_ hours: Int) -> Date {
		return dateByAdding(component: .hour, value: hours)
	}
    
    private func dateByAdding(component: NSCalendar.Unit, value: Int) -> Date {
        return (Calendar.current as NSCalendar).date(
            byAdding: component,
            value: value,
            to: self,
            options: []
            ) ?? self
    }
}

extension Date {
    
    init(year: Int, month: Int, day: Int) {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        dateComponent.year = year
        dateComponent.month = month
        dateComponent.day = day
        self = calendar.date(from: dateComponent) ?? Date()
    }
    
    func hour() -> Int {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.hour], from: self)
        return dateComponent.hour ?? 0
    }
    
    func second() -> Int {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.second], from: self)
        return dateComponent.second ?? 0
    }
    
    func minute() -> Int {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.minute], from: self)
        return dateComponent.minute ?? 0
    }
    
    func day() -> Int {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.day], from: self)
        return dateComponent.day ?? 0
    }
    
    func weekday() -> Int {
        let calendar = Calendar.init(identifier: .hebrew)
        let dateComponent = calendar.dateComponents([.weekday], from: self)
        return dateComponent.weekday ?? 0
    }
    
    func month() -> Int {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.month], from: self)
        return dateComponent.month ?? 0
    }
    
    func year() -> Int {
        let calendar = Calendar.current
        let dateComponent = calendar.dateComponents([.year], from: self)
        return dateComponent.year ?? 0
    }
    
    static func == (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == ComparisonResult.orderedSame
    }
    
    static func < (lhs: Date, rhs: Date) -> Bool {
        return lhs.compare(rhs) == ComparisonResult.orderedAscending
    }
    
    static func > (lhs: Date, rhs: Date) -> Bool {
        return rhs.compare(lhs) == ComparisonResult.orderedAscending
    }
}
