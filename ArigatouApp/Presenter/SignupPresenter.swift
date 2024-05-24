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
        print("登録！")
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
}

extension SignupPresenter : ValidationPresenterInput {
}
