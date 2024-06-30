//
//  TotalCounter.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//
import Foundation

class TotalCounter: Counter {
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func setCount(_ count: Int) {
        defaults.set(count, forKey: UserDefaultsKeys.TOTAL_COUNT)
    }

    func getCount() -> Int {
        return defaults.integer(forKey: UserDefaultsKeys.TOTAL_COUNT)
    }

    func incrementCount() {
        var count = getCount()
        count += 1
        setCount(count)
    }
    
    func setCount(for key: String, count: Int) {
        fatalError("This method is not supported for TotalCounter")
    }
    
    func getCount(for key: String) -> Int {
        fatalError("This method is not supported for TotalCounter")
    }
    
    func incrementCount(for key: String) {
        fatalError("This method is not supported for TotalCounter")
    }
    
    func getAllCounts() -> [String : Int] {
        fatalError("This method is not supported for TotalCounter")
    }
}
