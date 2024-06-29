//
//  CounterFactory.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/29.
//

import Foundation

class CounterFactory {
    enum CountType {
        case total
        case daily
        case weekly
        case monthly
    }

    func create(type: CountType, defaults: UserDefaults = .standard) -> Counter {
        switch type {
        case .total:
            return TotalCounter(defaults: defaults)
        case .daily:
            return DailyCounter(defaults: defaults)
        case .weekly:
            return WeeklyCounter(defaults: defaults)
        case .monthly:
            return MonthlyCounter(defaults: defaults)
        }
    }
}
