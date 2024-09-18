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
    
    /// 指定されたDate型の日付を文字列にフォーマットして返す
    func currentDateString(date: Date = Date()) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.string(from: date)
    }
    
    /// 指定された文字列の日付をDate型にフォーマットして返す
    func currentDate(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return dateFormatter.date(from: dateString)
    }
    
    func currentWeekString(date: Date = Date()) -> String {
        var calendarWithLocale = calendar
        calendarWithLocale.timeZone = timeZone
        calendarWithLocale.locale = locale
        
        // 週の開始日を月曜日に設定する
        calendarWithLocale.firstWeekday = 2
        
        let year = calendarWithLocale.component(.yearForWeekOfYear, from: date)
        let weekOfYear = calendarWithLocale.component(.weekOfYear, from: date)
        
        return String(format: "%d-W%02d", year, weekOfYear)
    }
    
    func currentMonthString(date: Date = Date()) -> String {
        let monthFormatter = DateFormatter()
        monthFormatter.calendar = calendar
        monthFormatter.timeZone = timeZone
        monthFormatter.locale = locale
        monthFormatter.dateFormat = "yyyy-MM"
        
        return monthFormatter.string(from: date)
    }
    
}
