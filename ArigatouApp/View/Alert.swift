//
//  Alert.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/20.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // カスタムビューコントローラを使用してアラートを表示
            let alertVC = CustomAlertViewController(title: title, message: message)
            alertVC.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                self.present(alertVC, animated: true, completion: nil)
            }
        } else {
            // 通常のUIAlertControllerを使用してアラートを表示
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

// pad用の大きいサイズのアラート
class CustomAlertViewController: UIViewController {
    var alertTitle: String
    var alertMessage: String
    
    init(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 背景を半透明にする
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // アラートビューを作成
        let alertView = UIView()
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 10
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)
        
        // タイトルラベルを作成
        let titleLabel = UILabel()
        titleLabel.text = alertTitle
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        
        // メッセージラベルを作成
        let messageLabel = UILabel()
        messageLabel.text = alertMessage
        messageLabel.font = UIFont.boldSystemFont(ofSize: 28)
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(messageLabel)
        
        // OKボタンを作成
        let okButton = UIButton(type: .system)
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 40)
        okButton.translatesAutoresizingMaskIntoConstraints = false
        okButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(okButton)
        
        // レイアウトを設定
        NSLayoutConstraint.activate([
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            alertView.widthAnchor.constraint(equalToConstant: 400),
            alertView.heightAnchor.constraint(equalToConstant: 250),
            
            titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            messageLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -20),
            
            okButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 20),
            okButton.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            okButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
}
