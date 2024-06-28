//
//  WeeklyCountStrategy.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

import Foundation

class WeeklyCountStrategy: CountStrategy {
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
}
