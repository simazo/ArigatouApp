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
        
        // バリデーション
        if !validate(email: email, password: password, passwordConfirm: passwordConfirm) {
            return
        }
        // ユーザアカウント作成
        AuthManager.shared.createUser(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let user):
                var userMatchCount = MatchCount(
                    uid: user.uid,
                    count: UserDefaultsManager.getCount(),
                    updateAt: Date().timeIntervalSince1970
                )
                
                var matchCountManger = MatchCountManager(RealtimeDBMatchCountRepository())
                matchCountManger.create(userMatchCount)
                
                self.view?.showSignupSuccess()
            case .failure(let error):
                self.handleSignupError(error)
            }
        }

    }
    
    private func validate(email: String, password: String, passwordConfirm: String) ->Bool {
        
        guard validateEmail(email: email) else {
            view?.showSignupFailed(errorMessage: "メールアドレスが不正です")
            return false
        }
        
        guard  validatePassword(password: password) else {
            view?.showSignupFailed(errorMessage: "パスワードが不正です")
            return false
        }
        
        guard  validatePassword(password: passwordConfirm) else {
            view?.showSignupFailed(errorMessage: "パスワード確認が不正です")
            return false
        }
        
        guard password == passwordConfirm else {
            view?.showSignupFailed(errorMessage: "パスワードが一致しません")
            return false
        }
        
        return true
    }
    
    private func handleSignupError(_ error: Error?) {
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

extension SignupPresenter : ValidationPresenterInput {
}
