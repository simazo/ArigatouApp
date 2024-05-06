//
//  LoginPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/05.
//

import Firebase

protocol LoginPresenterInput: AnyObject {
    func validateLogin(email: String, password: String)
    func emailExists(email: String)
}

protocol LoginPresenterOutput: AnyObject {
    func validationSuccess()
    func validationFailed(errorMessage: String)
}

class LoginPresenter {
    private weak var view: LoginPresenterOutput?
    private let validator = Validator()
    
    init(view: LoginPresenterOutput) {
        self.view = view
    }
}
extension LoginPresenter : LoginPresenterInput {
    
    func emailExists(email: String) {
        
        checkIfEmailExists(email: email) { (exists, error) in
            if let error = error {
                // エラーが発生した場合のハンドリング
                print("エラー: \(error.localizedDescription)")
                return
            }
            
            if exists {
                print("\(email) は登録済みです。")
            } else {
                print("\(email) は未登録です。")
            }
        }
    }
    
    func checkIfEmailExists(email: String, completion: @escaping (Bool, Error?) -> Void) {
        // Auth.auth().fetchSignInMethods　非推奨
        /*
        Auth.auth().fetchSignInMethods(forEmail: email) { (methods, error) in
            if let error = error {
                // エラーが発生した場合は、エラーをハンドリングしてメールが登録されているかどうかを確認することができません。
                print("エラー: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if let methods = methods {
                // メソッドが nil でない場合、そのメールアドレスは登録済みです。
                if methods.isEmpty {
                    // 登録されていない場合
                    completion(false, nil)
                } else {
                    // 登録されている場合
                    completion(true, nil)
                }
            } else {
                // メソッドが nil の場合、エラーをハンドリングしてメールが登録されているかどうかを確認することができません。
                print("メソッドが nil です。")
                completion(false, nil)
            }
        }
         */
    }
    
    func validateLogin(email: String, password: String) {
        
        guard validator.isEmail(email) else {
            view?.validationFailed(errorMessage: "メールアドレスが不正です")
            return
        }
        
        guard validator.isPassword(password) else {
            view?.validationFailed(errorMessage: "パスワードが不正です")
            return
        }
        
        view?.validationSuccess()
    }
}
