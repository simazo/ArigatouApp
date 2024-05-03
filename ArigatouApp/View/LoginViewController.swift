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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        self.title = ""
        
        initEmailTextField()
        initPasswordTextField()
    }
    
    func initEmailTextField(){
        emailTextField = UITextField()
        emailTextField.font = .boldSystemFont(ofSize: 20)
        
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
        passwordTextField.font = .boldSystemFont(ofSize: 20)
        
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
