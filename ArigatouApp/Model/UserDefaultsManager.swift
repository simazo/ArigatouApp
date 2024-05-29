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
    
    private let KEY = "matchCount"
    
    func getCount() -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: KEY)
    }

    func setCount(_ count: Int) {
        let defaults = UserDefaults.standard
        defaults.set(count, forKey: KEY)
    }
    
    // マッチ数をカウントアップする
    func incrementCount(){
        var count = self.getCount()
        count += 1
        self.setCount(count)
    }
}
