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

    // マッチ数を返す
    func getCount() -> Int {
        return matchCountRepository.getCount()
    }

    // マッチ数を保存する
    func setCount(_ count: Int){
        matchCountRepository.setCount(count)
    }

    // マッチ数をカウントアップする
    func incrementCount(){
        var count = matchCountRepository.getCount()
        count += 1
        matchCountRepository.setCount(count)
    }

}
