//
//  MatchCountManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/19.
//

class MatchCountManager {
    private let matchCountRepository: MatchCountRepository
    
    init(_ repository: MatchCountRepository){
        self.matchCountRepository = repository
    }
    
    func save(_ matchCount: MatchCount){
        matchCountRepository.save(matchCount)
    }
    
    func getCount() -> Int {
        return matchCountRepository.getCount()
    }
    
    func setCount(_ count: Int){
        matchCountRepository.setCount(count)
    }
    
    func incrementCount(){
        var count = matchCountRepository.getCount()
        count += 1
        matchCountRepository.setCount(count)
    }
     
}
