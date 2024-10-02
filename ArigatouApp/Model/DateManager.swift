//
//  DateManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

import Foundation

class DateManager {
    static let shared = DateManager()
    
    private var calendar: Calendar
    private let timeZone: TimeZone
    private let locale: Locale
    
    private init() {
        self.calendar = Calendar(identifier: .gregorian)
        self.calendar.firstWeekday = 1 // 1 = 日曜日を週の始まりに設定
        self.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        self.calendar.timeZone = self.timeZone
        self.locale = Locale(identifier: "ja_JP")
    }
    
    private func dateFormatter(withFormat format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = timeZone
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter
    }
    
    /// 指定された `Date` オブジェクトを "yyyy-MM-dd" 形式の文字列に変換します。
    /// - Parameter date: 変換する日付。デフォルトでは現在の日付が使用されます。
    /// - Returns: "yyyy-MM-dd" 形式の日付を表す文字列。
    func formattedDateString(date: Date = Date()) -> String {
        let formatter = dateFormatter(withFormat: "yyyy-MM-dd")
        return formatter.string(from: date)
    }
    
    /// 指定された日付文字列を `Date` 型に変換します。
    /// - Parameter dateString: "yyyy-MM-dd" 形式の日付を表す文字列。
    /// - Returns: 変換された `Date` オブジェクト。変換に失敗した場合は 1900/01/01 を返します。
    func formattedDate(_ dateString: String) -> Date {
        let formatter = dateFormatter(withFormat: "yyyy-MM-dd")
        // 日付がフォーマットに合わなかった場合は、1900年1月1日を返す
        return formatter.date(from: dateString) ?? defaultDate()
    }
    
    func defaultDate() -> Date {
        // 1900年1月1日のDateオブジェクトを作成して返す
        var components = DateComponents()
        components.year = 1900
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components) ?? Date()
    }
    
    /// 指定された `Date` オブジェクトに基づいて、その週を "yyyy-Wxx" 形式の文字列で返します。
    /// - Parameter date: 対象の日付。デフォルトでは現在の日付が使用されます。
    /// - Returns: "yyyy-Wxx" 形式の週を表す文字列。年と週番号が返されます。
    func formattedWeekString(date: Date = Date()) -> String {
        let year = calendar.component(.yearForWeekOfYear, from: date)
        let weekOfYear = calendar.component(.weekOfYear, from: date)
        return String(format: "%d-W%02d", year, weekOfYear)
    }
    

    /// 指定された週番号（"yyyy-Www" 形式）から翌週の週番号を計算して返す。
    /// 入力が無効な場合は現在の日付を基準に翌週の週番号を返す。
    /// - Parameter currentWeek: "yyyy-Www" 形式の週番号文字列（例: "2023-W23"）。
    /// - Returns: 翌週の週番号文字列（例: "2023-W24"）。無効な形式が渡された場合は、""（空文字）を返す。
    func nextWeek(from currentWeek: String) -> String {
        return week(from: currentWeek, addingWeeks: 1)
    }
    
    /// 指定された週番号（"yyyy-Www" 形式）から先週の週番号を計算して返す。
    /// 入力が無効な場合は現在の日付を基準に先週の週番号を返す。
    /// - Parameter currentWeek: "yyyy-Www" 形式の週番号文字列（例: "2023-W23"）。
    /// - Returns: 先週の週番号文字列（例: "2023-W22"）。無効な形式が渡された場合は、""（空文字）を返す。
    func previousWeek(from currentWeek: String) -> String {
        return week(from: currentWeek, addingWeeks: -1)
    }
    
    /// 指定された週番号文字列から、指定した数の週を加算または減算した週番号を計算して返します。
    /// - Parameter weekString: "yyyy-Www" 形式の週番号文字列（例: "2023-W23"）。
    /// - Parameter value: 加算または減算する週数。正の値で翌週、負の値で先週を指定します。
    /// - Returns: 計算された週番号文字列（例: "2023-W24"）。無効な形式が渡された場合は、空文字を返します。
    /// - Note: このメソッドは Gregorian カレンダーに基づき、週の始まりは日曜日です。
    func week(from weekString: String, addingWeeks value: Int) -> String {
        
        // 'W'が含まれているか確認
        guard weekString.contains("W") else {
            Swift.print("Invalid week format: \(weekString)")
            return ""
        }
        
        // weekString を分割して年と週番号を取得
        let components = weekString.components(separatedBy: "-W")
        guard components.count == 2,
              let year = Int(components[0]),
              let week = Int(components[1]) else {
            Swift.print("Invalid week format: \(weekString)")
            return ""
        }
        
        // 年と週番号を元に日付を作成
        var dateComponents = DateComponents()
        dateComponents.yearForWeekOfYear = year
        dateComponents.weekOfYear = week
        dateComponents.weekday = 1 // 日曜日に設定
        
        guard let validDate = calendar.date(from: dateComponents) else {
            print("Failed to create date from components: \(dateComponents)")
            return ""
        }
        
        // 週を加算または減算する
        guard let newDate = calendar.date(byAdding: .weekOfYear, value: value, to: validDate) else {
            print("Failed to calculate the new date.")
            return ""
        }
        
        // 新しい年と週番号を取得
        let newYear = calendar.component(.yearForWeekOfYear, from: newDate)
        let newWeek = calendar.component(.weekOfYear, from: newDate)
        
        let result = String(format: "%04d-W%02d", newYear, newWeek)
        
        return result
    }

    /// 指定された年月文字列から、指定した数の月を加算または減算した年月を計算して返します。
    /// - Parameter monthString: "yyyy-mm" 形式の年月文字列（例: "2023-06"）。
    /// - Parameter value: 加算または減算する月数。正の値で翌月、負の値で先月を指定します。
    /// - Returns: 計算された年月文字列（例: "2023-07"）。無効な形式が渡された場合は、空文字を返します。
    func month(from monthString: String, addingMonths value: Int) -> String {
        
        // monthString を分割して年と月を取得
        let components = monthString.components(separatedBy: "-")
        guard components.count == 2,
              let year = Int(components[0]),
              let month = Int(components[1]) else {
            Swift.print("Invalid month format: \(monthString)")
            return ""
        }
        
        // 年と月を元に日付を作成
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        
        // Calendarを使って日付を作成
        guard let validDate = calendar.date(from: dateComponents) else {
            print("Failed to create date from components: \(dateComponents)")
            return ""
        }
        
        // 月を加算または減算する
        guard let newDate = calendar.date(byAdding: .month, value: value, to: validDate) else {
            print("Failed to calculate the new date.")
            return ""
        }
        
        // 新しい年と月を取得
        let newYear = calendar.component(.year, from: newDate)
        let newMonth = calendar.component(.month, from: newDate)
        
        // 結果を "yyyy-mm" 形式にフォーマット
        let result = String(format: "%04d-%02d", newYear, newMonth)
        
        return result
    }

    /// 指定された `Date` オブジェクトに基づいて、その月を "yyyy-MM" 形式の文字列で返します。
    /// - Parameter date: 対象の日付。デフォルトでは現在の日付が使用されます。
    /// - Returns: "yyyy-MM" 形式の月を表す文字列。
    func formattedMonthString(date: Date = Date()) -> String {
        let formatter = dateFormatter(withFormat: "yyyy-MM")
        return formatter.string(from: date)
    }
    
    /// 文字列の週番号から数値の年と週番号を抽出します。
    ///
    /// - パラメータ weekString: "YYYY-Www" 形式の週番号を表す文字列です。YYYY は年、Www は週番号を示します (例: "2023-W10")。
    /// - 戻り値: 年と週番号を整数で含むタプルを返します。入力文字列が無効または解析できない場合は、エラーメッセージを出力し、デフォルト値 (1900, 1) を返します。
    ///
    /// - 注意: 入力文字列が期待される形式でない場合、デフォルト値 (1900, 1) が返されます。
    ///   週番号は "W" 文字の後に続き、有効な整数である必要があります。
    func extractYearAndWeek(from weekString: String) -> (year: Int, week: Int) {
        // "-"で分割して、年と週番号を取得
        let components = weekString.split(separator: "-").map { String($0) }
        
        // 年と週番号が正常に取得できるかをguardでチェック
        guard components.count == 2,
              let year = Int(components[0]),
              let week = Int(components[1].dropFirst()) else {
            // エラーメッセージを出力し、デフォルト値を返す
            print("無効な入力です。デフォルト値 (1900-W01) を返します。")
            return (1900, 1)
        }
        
        return (year, week)
    }
    
    /// 指定された年と週番号に基づいて日付を作成します。
    ///
    /// - Parameters:
    ///   - year: 週番号が属する年（例: 2024）
    ///   - week: 年内の週番号（例: 1〜53）
    ///
    /// - Returns: 指定された年と週番号の最初の日（週の最初の日、通常は日曜日）の `Date` オブジェクト。
    ///   TODO : バリデーション未対応
    func dateFor(year: Int, week: Int) -> Date {
        // 年と週番号を元に日付を作成
        var dateComponents = DateComponents()
        dateComponents.yearForWeekOfYear = year
        dateComponents.weekOfYear = week
        dateComponents.weekday = 1 // 日曜日に設定
        
        return calendar.date(from: dateComponents)!
    }
    
    /// 2つの週番号間の週の差を計算します。
    ///
    /// - Parameters:
    ///   - week1: 最初の週を表す文字列（形式: "YYYY-Www"、例: "2024-W12"）
    ///   - week2: 2つ目の週を表す文字列（形式: "YYYY-Www"、例: "2024-W14"）
    ///
    /// - Returns: week1 から week2 までの週の差を示す整数。
    ///   week1 が week2 より後の場合は負の値が返され、
    ///   どちらかの週が無効な場合は 0 が返されます。
    func weeksDifference(from week1: String, to week2: String) -> Int {
        let from = extractYearAndWeek(from: week1)
        let to = extractYearAndWeek(from: week2)
        
        let fromDate = dateFor(year: from.year, week: from.week)
        let toDate = dateFor(year: to.year, week: to.week)
        
      
        let difference = calendar.dateComponents([.weekOfYear], from: fromDate, to: toDate)
        
        guard let weekDifference = difference.weekOfYear else {
            return 0
        }
            
        return weekDifference
    }
    
}

