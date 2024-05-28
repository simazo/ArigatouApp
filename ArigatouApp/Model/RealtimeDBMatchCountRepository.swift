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
    
    func getUserMatchCount(completion: @escaping (Result<[String: Any], Error>) -> Void) {
        let userMatchCountRef = database.child("userMatchCount").child(self.uid)
        
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
            
            // 成功
            completion(.success(value))
        }
    }
    
    // プロトコル実装のため追加したけど使う予定ない・・・
    func getCount() -> Int {
        var retCount = 0
        getUserMatchCount { result in
            switch result {
            case .success(let data):
                if let count = data["count"] as? Int {
                    retCount = count
                } else {
                    let error = NSError(domain: "com.Arigatouapp", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to parse count from data"])
                    print("Error: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        return retCount
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
