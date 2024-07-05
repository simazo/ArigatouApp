//
//  DateManagerTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/07/05.
//

import XCTest
@testable import ArigatouApp

class DateManagerTests: XCTestCase {
    func testCurrentDateString() {
        let dateManager = DateManager.shared
        
        // 任意の日付でテスト
        let testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 2))!
        let expectedDateString = "2024-07-02"
        
        XCTAssertEqual(dateManager.currentDateString(date: testDate), expectedDateString)
        
        // 現在日でテスト
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let currentDateString = dateFormatter.string(from: currentDate)
        
        XCTAssertEqual(dateManager.currentDateString(), currentDateString)
            
    }
    
    func testCurrentWeekString() {
        let dateManager = DateManager.shared
        
        // 週の境目でテスト
        var testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 30))!
        var expectedWeekString = "2024-W26"
        
        XCTAssertEqual(dateManager.currentWeekString(date: testDate), expectedWeekString)
        
        // 週の境目でテスト
        testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 7, day: 1))!
        expectedWeekString = "2024-W27"
        
        XCTAssertEqual(dateManager.currentWeekString(date: testDate), expectedWeekString)
       
        // 現在の週でのテスト
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var calendarWithLocale = calendar
        calendarWithLocale.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendarWithLocale.locale = Locale(identifier: "ja_JP")
        calendarWithLocale.firstWeekday = 2
        
        let currentYear = calendarWithLocale.component(.yearForWeekOfYear, from: currentDate)
        let currentWeekOfYear = calendarWithLocale.component(.weekOfYear, from: currentDate)
        let currentWeekString = String(format: "%d-W%02d", currentYear, currentWeekOfYear)
        
        XCTAssertEqual(dateManager.currentWeekString(), currentWeekString)
    }
    
    func testCurrentMonthString() {
        let dateManager = DateManager.shared
        
        // 任意の月でテスト
        let testDate = Calendar.current.date(from: DateComponents(year: 2023, month: 7, day: 2))!
        let expectedMonthString = "2023-07"
        
        XCTAssertEqual(dateManager.currentMonthString(date: testDate), expectedMonthString)
        
        // 現在の月でのテスト
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy-MM"
        let currentMonthString = dateFormatter.string(from: currentDate)
        
        XCTAssertEqual(dateManager.currentMonthString(), currentMonthString)
    }
}
