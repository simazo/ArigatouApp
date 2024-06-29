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

    func incrementCount(for key: String) {
        var count = getCount(for: key)
        count += 1
        setCount(for: key, count: count)
    }
    
    func setCount(_ count: Int) {
        // 呼ばれたら例外発生させる
    }
    
    func getCount() -> Int {
        // 呼ばれたら例外発生させる
        return 0
    }
    
    func incrementCount() {
        // 呼ばれたら例外発生させる
    }
}
