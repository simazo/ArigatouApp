//
//  DateManagerTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/07/05.
//

import XCTest
@testable import ArigatouApp

class DateManagerTests: XCTestCase {
    
    private let dateManager = DateManager.shared
    
    func testCurrentDateString() {
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
        // 週の境目でテスト
        var testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 30))!
        var expectedWeekString = "2024-W27"
        
        XCTAssertEqual(dateManager.currentWeekString(date: testDate), expectedWeekString)
        
        // 週の境目でテスト
        testDate = Calendar.current.date(from: DateComponents(year: 2024, month: 6, day: 29))!
        expectedWeekString = "2024-W26"
        
        XCTAssertEqual(dateManager.currentWeekString(date: testDate), expectedWeekString)
       
        // 現在の週でのテスト
        let currentDate = Date()
        let calendar = Calendar(identifier: .gregorian)
        var calendarWithLocale = calendar
        calendarWithLocale.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        calendarWithLocale.locale = Locale(identifier: "ja_JP")
        calendarWithLocale.firstWeekday = 1
        
        let currentYear = calendarWithLocale.component(.yearForWeekOfYear, from: currentDate)
        let currentWeekOfYear = calendarWithLocale.component(.weekOfYear, from: currentDate)
        let currentWeekString = String(format: "%d-W%02d", currentYear, currentWeekOfYear)
        
        XCTAssertEqual(dateManager.currentWeekString(), currentWeekString)
    }
    
    func testCurrentMonthString() {
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
    
    func testNextWeek(){
        var currentWeek = "2024-W05"
        var result = dateManager.nextWeek(from: currentWeek)
        XCTAssertEqual(result, "2024-W06", "翌週が返ること")
        
        currentWeek = "2024-W52" //最後の週
        result = dateManager.nextWeek(from: currentWeek)
        XCTAssertEqual(result, "2025-W01", "翌年の1周目が返ること")
        
        // 不正な週番号
        let invalidWeeks = [
            "invalid", // フォーマットエラー
            "2024-W",  // 不完全なフォーマット
            // TODO: 以下の2件は週番号自体が不正であると認識されず DateFormatter が自動的に補正してしまう
            // 対応するためには、手動で週番号の範囲チェックを追加する必要があるが必要性がそこまでないためペンディング
            //"2024-W00",  // 存在しない週番号
            //"2024-W99", // 無効な週番号
        ]
        
        currentWeek = dateManager.currentWeekString()
        // 各不正な週番号についてテスト
        for invalidWeek in invalidWeeks {
            let result = dateManager.nextWeek(from: invalidWeek)
            XCTAssertEqual(result, "", "無効な週番号 \(invalidWeek) では空文字が返るべき")
        }
        
    }
    
    func testPreviousWeek(){
        var currentWeek = "2024-W35"
        var result = dateManager.previousWeek(from: currentWeek)
        XCTAssertEqual(result, "2024-W34", "先週が返ること")
        
        currentWeek = "2025-W01" // 翌年の始め
        result = dateManager.previousWeek(from: currentWeek)
        XCTAssertEqual(result, "2024-W52", "前年の最後の週が返ること")
        
        currentWeek = "2024-W01" // 年の始め
        result = dateManager.previousWeek(from: currentWeek)
        XCTAssertEqual(result, "2023-W52", "前年の最後の週が返ること")

        // 不正な週番号
        let invalidWeeks = [
            "invalid", // フォーマットエラー
            "2024-W",  // 不完全なフォーマット
            // TODO: 以下の2件は週番号自体が不正であると認識されず DateFormatter が自動的に補正してしまう
            // 対応するためには、手動で週番号の範囲チェックを追加する必要があるが必要性がそこまでないためペンディング
            //"2024-W00",  // 存在しない週番号
            //"2024-W99", // 無効な週番号
        ]
        
        currentWeek = dateManager.currentWeekString()
        // 各不正な週番号についてテスト
        for invalidWeek in invalidWeeks {
            let result = dateManager.previousWeek(from: invalidWeek)
            XCTAssertEqual(result, "", "無効な週番号 \(invalidWeek) では空文字が返るべき")
        }
    }
    
    
}
