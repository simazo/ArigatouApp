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
    
    init(uid: String) {
        self.uid = uid
    }
    
    func getCount() -> Int {
        <#code#>
    }
    
    func setCount(_ count: Int) {
        <#code#>
    }
    
    func createData(uid: String, matchCount: Int, completion: @escaping (Bool) -> Void) {
        let userData = [
            "uid": uid,
            "matchCount": matchCount
        ] as [String : Any]
        
        database.child("users").child(uid).setValue(userData) { error, _ in
            if let error = error {
                print("データの保存に失敗しました: \(error.localizedDescription)")
                completion(false)
            } else {
                print("データの保存に成功しました")
                completion(true)
            }
        }
    }
    
}
