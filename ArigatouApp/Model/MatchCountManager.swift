//
//  MatchCountManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

class MatchCountManager {
    
    private var matchCountRepository: MatchCountRepository

    init (_ repository: MatchCountRepository) {
        self.matchCountRepository = repository
    }

    func create(_ matchCount: MatchCount, completion: @escaping (Bool, Error?) -> Void) {
        self.matchCountRepository.create(matchCount, completion: completion)
    }
    
    func findByUid(uid: String, completion: @escaping (Result<MatchCount, Error>) -> Void) {
        self.matchCountRepository.findByUid(uid: uid, completion: completion)
    }
}
