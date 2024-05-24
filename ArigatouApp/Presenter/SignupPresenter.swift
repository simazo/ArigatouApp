//
//  SignupPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/24.
//

import Firebase

protocol SignupPresenterInput: AnyObject {
    func signUp(email: String, password: String)
}

protocol SignupPresenterOutput: AnyObject {
    func showValidationFailed(errorMessage: String)
    func showSignupSuccess()
    func showSignupFailed(errorMessage: String)
}


class SignupPresenter {
    
}

extension SignupPresenter : ValidationPresenterInput {
}
