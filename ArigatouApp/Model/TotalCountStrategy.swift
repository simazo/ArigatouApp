//
//  TotalCountStrategy.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//
import Foundation

class TotalCountStrategy: CountStrategy {
    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func setCount(for key: String = UserDefaultsKeys.TOTAL_COUNT, count: Int) {
        defaults.set(count, forKey: key)
    }

    func getCount(for key: String = UserDefaultsKeys.TOTAL_COUNT) -> Int {
        return defaults.integer(forKey: key)
    }

    func incrementCount(for key: String = UserDefaultsKeys.TOTAL_COUNT) {
        var count = getCount(for: key)
        count += 1
        setCount(for: key, count: count)
    }
}
