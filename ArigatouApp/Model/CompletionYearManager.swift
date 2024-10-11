//
//  CompletionYearManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/10.
//

import Foundation

class CompletionYearManager {
    static let shared = CompletionYearManager()
    
    private init() {}
    
    func get() -> Double {
        let defaultValue: Double = 1
        let completionYear = UserDefaults.standard.double(forKey: "CompletionYear")
        
        // はキーが存在しない場合 0 を返すため、0 の場合はデフォルト値にする
        return completionYear != 0 ? completionYear : defaultValue
    }
    
    func set(_ year: Double) {
        UserDefaults.standard.set(year, forKey: "CompletionYear")
    }
    
    // 達成したい年数によって１日あたりの目標数を算出して返す
    func targetCountPerDay(_ year: Double) -> Double {
        let days = 365 * year
        let countPerDay = 1000000 / days
        
        // 小数点第一位まで四捨五入
        return round(countPerDay * 10) / 10
    }
    
    // １日あたりの達成率を返す
    func calcDailyAchievementRate(dailyCount: Int) -> Double {
        let year = CompletionYearManager.shared.get()
        let countPerDay = CompletionYearManager.shared.targetCountPerDay(year)
        
        let achievementRate =  Double(dailyCount) / countPerDay * 100
        return round(achievementRate * 10) / 10  // 小数点以下1桁に四捨五入
    }
}
