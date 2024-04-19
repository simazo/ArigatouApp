//
//  UserDefaultsUserCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/19.
//

import Foundation

class UserDefaultsMatchCountRepository: MatchCountRepository {
    private let matchCountKey = "matchCount"
    
    func save(_ matchCount: MatchCount) {
    }
    
    func getCount() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: matchCountKey)
    }
    
    func setCount(_ count: Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: matchCountKey)
    }
}
