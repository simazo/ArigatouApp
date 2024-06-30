//
//  Counter.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

protocol Counter {
    // 総合計クラスで実装し、日別、週別、月別では実装しない
    func setCount(_ count: Int)
    func getCount() -> Int
    func incrementCount()
    
    // 日別、週別、月別で実装し、総合的クラスでは実装しない
    func setCount(for key: String, count: Int)
    func getCount(for key: String) -> Int
    func incrementCount(for key: String)
    func getAllCounts() -> [String: Int]
}
