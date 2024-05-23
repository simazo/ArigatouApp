//
//  LoginPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/05.
//

import Firebase

protocol LoginPresenterInput: AnyObject {
    func validate(email: String, password: String)
    func login(email: String, password: String)
    func passwordResetRequest(email: String)
}

protocol LoginPresenterOutput: AnyObject {
    func showValidationFailed(errorMessage: String)
    func showLoginSuccess()
    func showLoginFailed(errorMessage: String)
}

class LoginPresenter {
    private weak var view: LoginPresenterOutput?
    private let validator = Validator()
    
    init(view: LoginPresenterOutput) {
        self.view = view
    }
}
extension LoginPresenter : LoginPresenterInput {
    func passwordResetRequest(email: String) {
        AuthManager.shared.sendPasswordReset(email: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
            } else {
                print("Password reset email sent successfully.")
            }
        }
    }
    
    func validate(email: String, password: String) {
        
        guard validator.isEmail(email) else {
            view?.showValidationFailed(errorMessage: "メールアドレスが不正です")
            return
        }
        
        guard validator.isPassword(password) else {
            view?.showValidationFailed(errorMessage: "パスワードが不正です")
            return
        }
    }
    
    func login(email: String, password: String) {
        // バリデーション
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
    
}
