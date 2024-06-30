//
//  RealtimeDBCountRepository.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/25.
//

import FirebaseDatabase
import FirebaseDatabaseInternal

class RealtimeDBCountRepository: CountRepository {
    let database = Database.database().reference()
    
    func create(_ count: Count, completion: @escaping (Bool, Error?) -> Void) {
        let data = [
            "total_count": count.totalCount,
            "daily_count": count.dailyCount,
            "weekly_count": count.weeklyCount,
            "monthly_count": count.monthlyCount,
            "updatedAt": count.updateAt
        ] as [String : Any]
        
        database.child("Count").child(count.uid).setValue(data){ error, _ in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func findByUid(uid:String, completion: @escaping (Result<Count, Error>) -> Void) {
        let countRef = database.child("Count").child(uid)
        
        countRef.getData { error, snapshot in
            
            // エラーが発生した場合
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // データが取得できなかった場合
            guard let value = snapshot?.value as? [String: Any] else {
                let error = NSError(domain: "com.Arigatouapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch count"])
                completion(.failure(error))
                return
            }
            
            // データをCountに変換
            if let totalCount = value["total_count"] as? Int,
               let dailyCount = value["daily_count"] as? [String: Int],
               let weeklyCount = value["weekly_count"] as? [String: Int],
               let monthlyCount = value["monthly_count"] as? [String: Int],
               let updatedAt = value["updatedAt"] as? Double {
                let count = Count(uid: uid, totalCount: totalCount, dailyCount: dailyCount, weeklyCount: weeklyCount, monthlyCount: monthlyCount, updateAt: updatedAt)
                completion(.success(count))
            } else {
                let error = NSError(domain: "com.Arigatouapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid data format"])
                completion(.failure(error))
            }
        }
    }
}
