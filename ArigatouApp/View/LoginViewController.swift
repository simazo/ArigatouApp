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
        initPasswordResetButton()
        
        presenter = LoginPresenter(view: self)
    }
    
    func initPasswordResetButton() {
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
                                      action: #selector(LoginViewController.buttonPasswordResetTapped(sender:)),
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
    
    @objc func buttonPasswordResetTapped(sender : Any) {
        var alertTextField: UITextField?
        
        let message = """
            アカウント登録したメールアドレスをご入力ください。\n
            パスワード変更の案内を送信します。
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
                    if (alertTextField?.text) != nil {
                        self.presenter.passwordReset(email: alertTextField!.text!)
                        // アラートでメッセージを表示する
                        let successAlert = UIAlertController(
                            title: "送信完了",
                            message: "パスワード変更の案内を送信しました",
                            preferredStyle: .alert)
                        
                        successAlert.addAction(UIAlertAction(
                            title: "OK",
                            style: .default,
                            handler: nil))
                        
                        self.present(successAlert, animated: true, completion: nil)
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
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showLoginFailed(errorMessage: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "ログインエラー", message: errorMessage)
        }
    }
}
