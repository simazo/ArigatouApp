//
//  Calorie.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/17.
//

import Foundation

class Calorie {
    static let shared = Calorie()
    private init() {}
    
    // 1分間に1キロカロリー消費すると仮定すると1秒あたり約0.016キロカロリー、１発話２秒として算出→0.032
    //private let A_CALORIE = 0.032
    private let A_CALORIE = 0.32 // 低すぎてモチベーションにならないので大声として概算計算
    
    
    
    func getCaloriesBurned(count: Double) -> Double {
        return count * A_CALORIE
    }
}
