//
//  MatchCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

protocol MatchCountRepository {
    func getCount() -> Int
    func setCount(_ count: Int)
}
