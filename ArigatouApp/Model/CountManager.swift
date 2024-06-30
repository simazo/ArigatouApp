//
//  CountManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

class CountManager {
    
    private var countRepository: CountRepository

    init (_ repository: CountRepository) {
        self.countRepository = repository
    }

    func create(_ count: Count, completion: @escaping (Bool, Error?) -> Void) {
        self.countRepository.create(count, completion: completion)
    }
    
    func findByUid(uid: String, completion: @escaping (Result<Count, Error>) -> Void) {
        self.countRepository.findByUid(uid: uid, completion: completion)
    }
}
