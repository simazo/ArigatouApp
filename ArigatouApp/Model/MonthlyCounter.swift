//
//  MonthlyCounter.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

import Foundation

class MonthlyCounter: Counter {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }
    
    func setCount(for key: String, count: Int) {
        var monthlyCount = defaults.dictionary(forKey: UserDefaultsKeys.MONTHLY_COUNT) as? [String: Int] ?? [:]
        monthlyCount[key] = count
        defaults.set(monthlyCount, forKey: UserDefaultsKeys.MONTHLY_COUNT)
    }
    
    func getCount(for key: String) -> Int {
        if let monthlyCount = defaults.dictionary(forKey: UserDefaultsKeys.MONTHLY_COUNT) as? [String: Int] {
            return monthlyCount[key] ?? 0
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
        return defaults.dictionary(forKey: UserDefaultsKeys.MONTHLY_COUNT) as? [String: Int] ?? [:]
    }
    
    /// UserDefaultsから最小月を返す
    /// アプリインストール直後など、まだ月が存在しない場合は現在月を返す
    func minDate() -> String{
        if let monthlyCount = defaults.dictionary(forKey: UserDefaultsKeys.MONTHLY_COUNT) as? [String: Int] {
            if let minDateString = monthlyCount.keys.min() {
                return minDateString
            }
        }
        return DateManager.shared.currentMonthString()
    }
    
    func setCount(_ count: Int) {
        fatalError("This method is not supported for MonthlyCounter")
    }
    
    func getCount() -> Int {
        fatalError("This method is not supported for MonthlyCounter")
    }
    
    func incrementCount() {
        fatalError("This method is not supported for MonthlyCounter")
    }
}
