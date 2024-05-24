//
//  LoginPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/05.
//

import Firebase

protocol LoginPresenterInput: AnyObject {
    func login(email: String, password: String)
    func passwordReset(email: String)
}

protocol LoginPresenterOutput: AnyObject {
    func showLoginSuccess()
    func showLoginFailed(errorMessage: String)
}

class LoginPresenter {
    private weak var view: LoginPresenterOutput?
    
    init(view: LoginPresenterOutput) {
        self.view = view
    }
}
extension LoginPresenter : LoginPresenterInput {
    func passwordReset(email: String) {
        AuthManager.shared.sendPasswordReset(email: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
            } else {
                print("Password reset email sent successfully.")
            }
        }
    }
    
    func login(email: String, password: String) {
        
        validate(email: email, password: password)
        
        AuthManager.shared.login(email: email, password: password) { [weak self] success, error in
            guard let self = self else { return }
            
            // ログイン成功
            if success {
                self.view?.showLoginSuccess()
                return
            }
            
            // ログイン失敗
            if let error = error as NSError? {
                let errorMessage: String
                
                switch error.code {
                case AuthErrorCode.invalidCredential.rawValue:
                    errorMessage = "提供された認証情報が不正か期限切れです。"
                case AuthErrorCode.userDisabled.rawValue:
                    errorMessage = "このアカウントは無効化されています。"
                case AuthErrorCode.wrongPassword.rawValue:
                    errorMessage = "パスワードが間違っています。"
                case AuthErrorCode.invalidEmail.rawValue:
                    errorMessage = "メールアドレスの形式が正しくありません。"
                case AuthErrorCode.tooManyRequests.rawValue:
                    errorMessage = "ログインが何度も失敗したため、一時的にアクセス制限されました。パスワードをリセットするか、時間をしばらく置いて再度ログインしてください。"
                    
                default:
                    errorMessage = error.localizedDescription
                }
                
                self.view?.showLoginFailed(errorMessage: errorMessage)
            } else {
                self.view?.showLoginFailed(errorMessage: "ログインエラー")
            }
        }
    }
    
    private func validate(email: String, password: String) {
        
        guard validateEmail(email: email) else {
            view?.showLoginFailed(errorMessage: "メールアドレスが不正です")
            return
        }
        
        guard  validatePassword(password: password) else {
            view?.showLoginFailed(errorMessage: "パスワードが不正です")
            return
        }
    }
}

extension LoginPresenter : ValidationPresenterInput {
}
