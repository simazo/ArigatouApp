//
//  MatchCountManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/21.
//

class MatchCountManager {
    private let matchCountRepository: MatchCountRepository

    // リポジトリ先を登録
    init(_ repository: MatchCountRepository){
        self.matchCountRepository = repository
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
