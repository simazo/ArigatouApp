//
//  CountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

protocol CountRepository {
    func create(_ count: Count, completion: @escaping (Bool, Error?) -> Void)
    func findByUid(uid:String, completion: @escaping (Result<Count, Error>) -> Void)
}
