//
//  RealtimeDBMatchCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/25.
//

import FirebaseDatabase
import FirebaseDatabaseInternal

class RealtimeDBMatchCountRepository: MatchCountRepository {
    let database = Database.database().reference()
    
    func create(_ matchCount: MatchCount, completion: @escaping (Bool, Error?) -> Void) {
        let userData = [
            "count": matchCount.count,
            "updatedAt": matchCount.updateAt
        ] as [String : Any]
        
        database.child("userMatchCount").child(matchCount.uid).setValue(userData){ error, _ in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func findByUid(uid:String, completion: @escaping (Result<MatchCount, Error>) -> Void) {
        let userMatchCountRef = database.child("userMatchCount").child(uid)
        
        userMatchCountRef.getData { error, snapshot in
            
            // エラーが発生した場合
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // データが取得できなかった場合
            guard let value = snapshot?.value as? [String: Any] else {
                let error = NSError(domain: "com.Arigatouapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch user match count data"])
                completion(.failure(error))
                return
            }
            
            // データをMatchCountに変換
            if let count = value["count"] as? Int,
               let updatedAt = value["updatedAt"] as? Double {
                let matchCount = MatchCount(uid: uid, count: count, updateAt: updatedAt)
                completion(.success(matchCount))
            } else {
                let error = NSError(domain: "com.Arigatouapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                completion(.failure(error))
            }
        }
    }
}
