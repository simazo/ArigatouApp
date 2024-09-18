//
//  WeeklyCounter.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

import Foundation

class WeeklyCounter: Counter {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func setCount(for key: String, count: Int) {
        var weeklyCount = defaults.dictionary(forKey: UserDefaultsKeys.WEEKLY_COUNT) as? [String: Int] ?? [:]
        weeklyCount[key] = count
        defaults.set(weeklyCount, forKey: UserDefaultsKeys.WEEKLY_COUNT)
    }
    
    func getCount(for key: String) -> Int {
        if let weeklyCount = defaults.dictionary(forKey: UserDefaultsKeys.WEEKLY_COUNT) as? [String: Int] {
            return weeklyCount[key] ?? 0
        }
        return 0
    }
    
    func incrementCount(for key: String) {
        var count = getCount(for: key)
        count += 1
        setCount(for: key, count: count)
    }
    
    // UserDefaultsからすべてのカウントを取得
    func getAllCounts() -> [String: Int] {
        let defaults = UserDefaults.standard
        return defaults.dictionary(forKey: UserDefaultsKeys.WEEKLY_COUNT) as? [String: Int] ?? [:]
    }
    
    /// UserDefaultsから最小週を返す
    /// アプリインストール直後などまだ週が存在しない場合は現在週を返す
    /// nilを返すことはありません
    func minDate() -> String{
        if let weeklyCount = defaults.dictionary(forKey: UserDefaultsKeys.WEEKLY_COUNT) as? [String: Int] {
            if let minDateString = weeklyCount.keys.min() {
                return minDateString
            }
        }
        return DateManager.shared.currentWeekString()
    }
    
    func setCount(_ count: Int) {
        fatalError("This method is not supported for WeeklyCounter")
    }
    
    func getCount() -> Int {
        fatalError("This method is not supported for WeeklyCounter")
    }
    
    func incrementCount() {
        fatalError("This method is not supported for WeeklyCounter")
    }
}
