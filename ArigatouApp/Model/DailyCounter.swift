//
//  DailyCounter.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

import Foundation

class DailyCounter: Counter {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func setCount(for key: String, count: Int) {
        var dailyCount = defaults.dictionary(forKey: UserDefaultsKeys.DAILY_COUNT) as? [String: Int] ?? [:]
        dailyCount[key] = count
        defaults.set(dailyCount, forKey: UserDefaultsKeys.DAILY_COUNT)
    }

    func getCount(for key: String) -> Int {
        if let dailyCount = defaults.dictionary(forKey: UserDefaultsKeys.DAILY_COUNT) as? [String: Int] {
            return dailyCount[key] ?? 0
        }
        return 0
    }
    
    /// UserDefaultsから最小日付を返す
    /// アプリインストール直後などまだ日付が存在しない場合は現在日を返す
    /// nilを返すことはありません
    func minDate() -> String{
        if let dailyCount = defaults.dictionary(forKey: UserDefaultsKeys.DAILY_COUNT) as? [String: Int] {
            if let minDateString = dailyCount.keys.min() {
                return minDateString
            }
        }
        return DateManager.shared.formattedDateString()
    }

    func incrementCount(for key: String) {
        var count = getCount(for: key)
        count += 1
        setCount(for: key, count: count)
    }
    
    // UserDefaultsからすべてのカウントを取得
    func getAllCounts() -> [String: Int] {
        let defaults = UserDefaults.standard
        return defaults.dictionary(forKey: UserDefaultsKeys.DAILY_COUNT) as? [String: Int] ?? [:]
    }
    
    func setCount(_ count: Int) {
        fatalError("This method is not supported for DailyCounter")
    }
    
    func getCount() -> Int {
        fatalError("This method is not supported for DailyCounter")
    }
    
    func incrementCount() {
        fatalError("This method is not supported for DailyCounter")
    }
}
