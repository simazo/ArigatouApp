//
//  UserDefaultsMatchCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

import Foundation

class UserDefaultsMatchCountRepository: MatchCountRepository {
    
    private let matchCountKey = "matchCount"
    
    func setUid(uid: String) {
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "uid")
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
