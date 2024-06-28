//
//  CountStrategy.swift
//  ArigatouApp
//
//  Created by pero on 2024/06/28.
//

protocol CountStrategy {
    func setCount(for key: String, count: Int)
    func getCount(for key: String) -> Int
    func incrementCount(for key: String)
}
