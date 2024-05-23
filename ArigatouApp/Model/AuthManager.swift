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
    
    func checkUserAuthentication () -> Bool {
        if Auth.auth().currentUser != nil {
            // ユーザーがログインしている場合
            return true
        } else {
            // ユーザーがログインしていない場合
            return false
        }
    }
    
    func sendPasswordReset(email: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}

