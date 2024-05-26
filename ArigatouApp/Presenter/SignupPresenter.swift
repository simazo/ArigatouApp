//
//  SignupPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/24.
//

import Firebase

protocol SignupPresenterInput: AnyObject {
    func signup(email: String, password: String, passwordConfirm: String)
}

protocol SignupPresenterOutput: AnyObject {
    func showSignupSuccess()
    func showSignupFailed(errorMessage: String)
}

class SignupPresenter {
    private weak var view: SignupPresenterOutput?

    init(view: SignupPresenterOutput) {
        self.view = view
    }
}

extension SignupPresenter : SignupPresenterInput {
    func signup(email: String, password: String, passwordConfirm: String) {
        
        validate(email: email, password: password, passwordConfirm: passwordConfirm)
        AuthManager.shared.createUser(email: email, password: password) { [weak self] success, error in
            guard let self = self else { return }
            
            // ユーザ登録成功
            if success {
                print("RealtimeDB 登録へ")
                self.view?.showSignupSuccess()
                return
            }
            
            // ユーザ登録失敗
            if let error = error as NSError? {
                let errorMessage: String
                
                switch error.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    errorMessage = "このメールアドレスは既に使用されています。"
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "メールアドレスの形式が正しくありません。"
                case AuthErrorCode.weakPassword.rawValue:
                    errorMessage = "パスワードが短すぎます。"
                default:
                    errorMessage = error.localizedDescription
                }
                self.view?.showSignupFailed(errorMessage: errorMessage)
            } else {
                self.view?.showSignupFailed(errorMessage: "アカウント登録エラー")
            }
        }
    }
    
    private func validate(email: String, password: String, passwordConfirm: String) {
        
        guard validateEmail(email: email) else {
            view?.showSignupFailed(errorMessage: "メールアドレスが不正です")
            return
        }
        
        guard  validatePassword(password: password) else {
            view?.showSignupFailed(errorMessage: "パスワードが不正です")
            return
        }
        
        guard  validatePassword(password: passwordConfirm) else {
            view?.showSignupFailed(errorMessage: "パスワード確認が不正です")
            return
        }
        
        guard password == passwordConfirm else {
            view?.showSignupFailed(errorMessage: "パスワードが一致しません")
            return
        }
        
    }
    
    private func createUser(email: String, password: String) {
        
    }
}

extension SignupPresenter : ValidationPresenterInput {
}
