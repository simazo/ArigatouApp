//
//  ValidationPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/24.
//

protocol ValidationPresenterInput: AnyObject {
    func validateEmail(email: String) -> Bool
    func validatePassword(password: String) -> Bool
}


extension ValidationPresenterInput {
    func validateEmail(email: String) -> Bool {
        return Validator.isEmail(email)
    }
    
    func validatePassword(password: String) -> Bool {
        return Validator.isPassword(password)
    }
}

