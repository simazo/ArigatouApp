//
//  UserDefaultsManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private init() {}
    
    private let TOTAL_COUNT = "total_count"
    private let DAILY_COUNT = "daily_count"
    
    func getCount() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: TOTAL_COUNT)
    }

    func setCount(_ count: Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: TOTAL_COUNT)
    }
    
    // マッチ数をカウントアップする
    func incrementCount(){
        var count = self.getCount()
        count += 1
        self.setCount(count)
    }
    
    // 日別サマリを返す
    func getDailyCount(for yyyymmmdd: String) -> Int {
        let defaults = UserDefaults.standard
        if let dailyCount = UserDefaults.standard.dictionary(forKey: DAILY_COUNT) as? [String: Int] {
            return dailyCount[yyyymmmdd] ?? 0
        }
        return 0
    }
    
    // 日別サマリを書き込む
    func setDailyCount(for yyyymmdd: String, count: Int) {
        let defaults = UserDefaults.standard
        var dailyCount = defaults.dictionary(forKey: "daily_count") as? [String: Int] ?? [:]
        dailyCount[yyyymmdd] = count
        defaults.set(dailyCount, forKey: "daily_count")
    }
    
    // 日別サマリをカウントアップする
    func incrementDailyCount(for yyyymmmdd: String) {
        var count = self.getDailyCount(for: yyyymmmdd)
        count += 1
        self.setDailyCount(for: yyyymmmdd, count: count)
    }
    
    func getToday() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy-MM-dd" // 日付のフォーマットを指定

        let now = Date()
        return dateFormatter.string(from: now)
    }
    
    
}
