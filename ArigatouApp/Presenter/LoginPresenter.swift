//
//  LoginPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/05.
//

import Firebase

protocol LoginPresenterInput: AnyObject {
    func validateLogin(email: String, password: String)
    func exists(email: String)
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
    func exists(email: String) {
        // ユーザーのメールアドレス
        let userEmail = "user@example.com"

        // Firebase Authentication のメソッドを使用して登録済みかどうかを確認する
        firebase.auth().fetchSignInMethods(forEmail: userEmail) { providers, error in
            if let error = error {
                print("エラー：", error.localizedDescription)
                return
            }
            
            guard let providers = providers as? [String] else {
                print("プロバイダーが見つかりませんでした")
                return
            }
            
            if providers.contains(firebase.auth.EmailAuthProvider.emailPasswordSignInMethod()) {
                print("ユーザーは登録されています")
                // ここに登録されたユーザーに対する追加の処理を記述します
            } else {
                print("ユーザーは登録されていません")
                // ここに新しいユーザーの登録手続きを開始するための処理を記述します
            }
        }
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
