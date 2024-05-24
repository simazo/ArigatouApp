//
//  SignupPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/24.
//

import Firebase

protocol SignupPresenterInput: AnyObject {
    func signup(email: String, password: String)
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
    func signup(email: String, password: String) {
        print("登録！")
    }
    
}

extension SignupPresenter : ValidationPresenterInput {
}
