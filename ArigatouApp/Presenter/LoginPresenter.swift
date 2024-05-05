//
//  LoginPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/05.
//

protocol LoginPresenterInput: AnyObject {
    func validateLogin(email: String, password: String)
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
