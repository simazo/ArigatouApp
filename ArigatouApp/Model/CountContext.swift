//
//  CountContext.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

import Foundation

class CountContext {
    static let shared = CountContext()
    private let strategy: CountStrategy
    
    init(strategy: CountStrategy = TotalCountStrategy()) {
        self.strategy = strategy
    }
    
    func setCount(for key: String, count: Int) {
        strategy.setCount(for: key, count: count)
    }
    
    func getCount(for key: String) -> Int {
        return strategy.getCount(for: key)
    }
    
    func incrementCount(for key: String) {
        strategy.incrementCount(for: key)
    }
}
