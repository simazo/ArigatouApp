//
//  SignupViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/24.
//

import UIKit

class SignupViewController: UIViewController {
    private var emailTextField: UITextField!
    private var passwordTextField: UITextField!
    private var passwordConfirmTextField: UITextField!
    private var signupButton: UIButton!
    
    private var presenter: SignupPresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        self.title = "アカウント登録"
        
        initEmailTextField()
        initPasswordTextField()
        initPasswordConfirmTextField()
        initSignupButton()
        initInformationLabel()
        
        presenter = SignupPresenter(view: self)
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
    
    func initPasswordConfirmTextField(){
        passwordConfirmTextField = UITextField()
        passwordConfirmTextField.font = .boldSystemFont(ofSize: 16)
        
        passwordConfirmTextField.placeholder = "パスワード確認"
        passwordConfirmTextField.keyboardType = .alphabet
        passwordConfirmTextField.backgroundColor = UIColor.white
        passwordConfirmTextField.layer.borderWidth = 1
        passwordConfirmTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        passwordConfirmTextField.leftViewMode = .always
        passwordConfirmTextField.leftView = UIView(frame: .init(x: 0,
                                                 y: 0,
                                                 width: 10,
                                                 height: 0))

        passwordConfirmTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(passwordConfirmTextField)
        NSLayoutConstraint.activate([
            passwordConfirmTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0.0),
            passwordConfirmTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordConfirmTextField.widthAnchor.constraint(equalToConstant: 280),
            passwordConfirmTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func initSignupButton(){
        signupButton = UIButton()
        signupButton.setTitle("登録", for:UIControl.State.normal)
        signupButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        signupButton.backgroundColor = .systemBlue
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signupButton)
        NSLayoutConstraint.activate([
            signupButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50.0),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signupButton.widthAnchor.constraint(equalToConstant: 280),
            signupButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        signupButton.addTarget(self,
                              action: #selector(SignupViewController.buttonSignupTapped(sender:)),
                              for: .touchUpInside)
    }
 
    @objc func buttonSignupTapped(sender : Any) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {
            return
        }
        
        presenter.signup(email: email, password: password)
    }
    
    func initInformationLabel() {
        let infoLabel = UILabel()
        infoLabel.text = "説明文"
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        infoLabel.backgroundColor = .systemGray
        infoLabel.textAlignment = .center
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(infoLabel)
        NSLayoutConstraint.activate([
            infoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100),
            infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            infoLabel.widthAnchor.constraint(equalToConstant: 280),
            infoLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

extension SignupViewController: SignupPresenterOutput {
    func showSignupSuccess() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showSignupFailed(errorMessage: String) {
        self.showAlert(title: "アカウント登録エラー", message: errorMessage)
    }
    
    
}
