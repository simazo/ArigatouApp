//
//  MatchCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

protocol MatchCountRepository {
    func create(_ matchCount: MatchCount)
    func findByUid(uid:String, completion: @escaping (Result<MatchCount, Error>) -> Void)
}
