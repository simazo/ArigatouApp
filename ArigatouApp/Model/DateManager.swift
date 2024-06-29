//
//  DateManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

import Foundation

class DateManager {
    static let shared = DateManager()
    
    private let calendar: Calendar
    private let timeZone: TimeZone
    private let locale: Locale
    
    private init() {
        self.calendar = Calendar(identifier: .gregorian)
        self.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        self.locale = Locale(identifier: "ja_JP")
    }
    
    func currentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: Date())
    }
    
    func currentWeekString() -> String {
        let date = Date()
        var calendarWithLocale = calendar
        calendarWithLocale.timeZone = timeZone
        calendarWithLocale.locale = locale
        
        let year = calendarWithLocale.component(.yearForWeekOfYear, from: date)
        let weekOfYear = calendarWithLocale.component(.weekOfYear, from: date)
        
        return String(format: "%d-W%02d", year, weekOfYear)
    }
    
    func currentMonthString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "yyyy-MM"
        
        return dateFormatter.string(from: Date())
    }
    
}
