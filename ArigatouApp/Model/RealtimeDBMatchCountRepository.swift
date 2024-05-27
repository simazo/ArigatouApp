//
//  RealtimeDBMatchCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/25.
//

import FirebaseDatabase

class RealtimeDBMatchCountRepository: MatchCountRepository {  
    let database = Database.database().reference()
    var uid: String
    
    init (uid: String) {
        self.uid = uid
    }

    func getCount() -> Int {
        return 0 //TODO
    }
    
    func setCount(_ count: Int) {
        // 現在時刻をFirebaseのタイムスタンプとしてフォーマット
        let timestamp = Date().timeIntervalSince1970
        
        let userData = [
            "count": count,
            "updatedAt": timestamp
        ] as [String : Any]
        database.child("userMatchCount").child(uid).setValue(userData)
    }
}
