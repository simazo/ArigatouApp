//
//  AuthManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/10.
//

import Firebase

class AuthManager {
    static let shared = AuthManager()
    
    private init() {}
    
    func createUser(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else if let user = authResult?.user {
                completion(.success(user))
            } else {
                let unknownError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unknown error occurred"])
                completion(.failure(unknownError))
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                completion(false, error)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func logout(completion: @escaping (Bool, Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false, signOutError)
        }
    }
    
    /**
     ユーザーが現在ログインしているかどうかを確認し、ログイン状態とユーザーIDを返します。

     - Parameter completion: ログイン状態とユーザーIDを受け取るクロージャ。
       - `isAuthenticated`: ユーザーがログインしているかどうかを示すブール値。
       - `uid`: ユーザーがログインしている場合のユーザーID。ログインしていない場合は`nil`。
     */
    func isLoggedIn (completion: (Bool, String?) -> Void){
        if let user = Auth.auth().currentUser {
            // ユーザーがログインしている場合
            completion(true, user.uid)
        } else {
            // ユーザーがログインしていない場合
            completion(false, nil)
        }
    }
    
    func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}

