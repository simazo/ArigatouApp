//
//  MatchCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/19.
//

protocol MatchCountRepository {
    func save(_ matchCount: MatchCount)
    func getCount() -> Int
    //func getCountByUid(_ uid: String)
    func setCount(_ count: Int)
}
