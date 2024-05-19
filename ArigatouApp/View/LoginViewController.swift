//
//  LoginViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/26.
//

import UIKit

class LoginViewController: UIViewController {
    
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var loginButton: UIButton!
    private var resetPasswordButton: UIButton!
    
    private var presenter: LoginPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        self.title = "ログイン"
        
        initEmailTextField()
        initPasswordTextField()
        initLoginButton()
        initResetPasswordButton()
        
        presenter = LoginPresenter(view: self)
    }
    
    func initResetPasswordButton() {
        resetPasswordButton = UIButton()
        resetPasswordButton.setTitle("パスワードを忘れた場合はこちら", for:UIControl.State.normal)
        resetPasswordButton.titleLabel?.font =  UIFont.systemFont(ofSize: 14)
        resetPasswordButton.backgroundColor = .systemGray
        
        resetPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resetPasswordButton)
        NSLayoutConstraint.activate([
            resetPasswordButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 60),
            resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resetPasswordButton.widthAnchor.constraint(equalToConstant: 280),
            resetPasswordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        resetPasswordButton.addTarget(self,
                                      action: #selector(LoginViewController.buttonResetPasswordTapped(sender:)),
                                      for: .touchUpInside)
    }
    
    func initLoginButton(){
        loginButton = UIButton()
        loginButton.setTitle("ログイン", for:UIControl.State.normal)
        loginButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        loginButton.backgroundColor = .systemBlue
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        NSLayoutConstraint.activate([
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.widthAnchor.constraint(equalToConstant: 280),
            loginButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        loginButton.addTarget(self,
                              action: #selector(LoginViewController.buttonLoginTapped(sender:)),
                              for: .touchUpInside)
    }
    
    @objc func buttonResetPasswordTapped(sender : Any) {
        var alertTextField: UITextField?
        
        let message = """
            パスワードの変更を行うメールアドレスをご入力ください。\n
            入力したメールアドレスにパスワード変更の案内を送信します。
            """
        
        let alert = UIAlertController(
            title: "パスワード変更",
            message: message,
            preferredStyle: UIAlertController.Style.alert)

        alert.addTextField { textField in
            alertTextField = textField
            textField.text = self.emailTextField.text
            textField.placeholder = "メールアドレス"
        }
        
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "送信",
                style: UIAlertAction.Style.default) { _ in
                    if let text = alertTextField?.text {
                        self.presenter.accountExists(email: text)
                    }
                }
        )
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func buttonLoginTapped(sender : Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        presenter.login(email: email, password: password)
    }
    
    func initEmailTextField(){
        emailTextField = UITextField()
        emailTextField.font = .boldSystemFont(ofSize: 16)
        
        emailTextField.placeholder = "メールアドレス"
        emailTextField.keyboardType = .emailAddress
        emailTextField.backgroundColor = UIColor.white
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        emailTextField.leftViewMode = .always
        emailTextField.leftView = UIView(frame: .init(x: 0,
                                                 y: 0,
                                                 width: 10,
                                                 height: 0))

        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emailTextField)
        NSLayoutConstraint.activate([
            emailTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100.0),
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailTextField.widthAnchor.constraint(equalToConstant: 280),
            emailTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func initPasswordTextField(){
        passwordTextField = UITextField()
        passwordTextField.font = .boldSystemFont(ofSize: 16)
        
        passwordTextField.placeholder = "パスワード"
        passwordTextField.keyboardType = .alphabet
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = UIView(frame: .init(x: 0,
                                                 y: 0,
                                                 width: 10,
                                                 height: 0))

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50.0),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension LoginViewController : LoginPresenterOutput {
    func showLoginSuccess() {
        NotificationCenter.default.post(name: .loginSuccess, object: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func showLoginFailed(errorMessage: String) {
        showValidationFailed(errorMessage: errorMessage)
    }
    
    func showValidationFailed(errorMessage: String) {
        let alert = UIAlertController(title: "ログインエラー", message: errorMessage, preferredStyle: .alert)

        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(ok)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension Notification.Name {
    static let loginSuccess = Notification.Name("loginSuccess")
}
