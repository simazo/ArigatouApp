//
//  ViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import UIKit

class ViewController: UIViewController {
    private var labelCounter: PaddingLabel!
    
    private var presenter: PresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLabel()
        presenter = SpeechPresenter(view: self)
        presenter.viewDidLoad()
    }
    
    func initLabel(){
        labelCounter = PaddingLabel(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        
        labelCounter.text = "現在、\n0回"
        labelCounter.font = .systemFont(ofSize: 20)
        labelCounter.backgroundColor = UIColor.systemOrange
        labelCounter.textColor = .white
        labelCounter.textAlignment = .center
        labelCounter.numberOfLines = 0
        // 角丸に変更
        labelCounter.layer.cornerRadius = 15
        labelCounter.clipsToBounds = true
        
        // 中央に配置
        labelCounter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(labelCounter)
        NSLayoutConstraint.activate([
            labelCounter.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            labelCounter.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
extension ViewController: PresenterOutput{
    func refreshLabelText(text: String) {
        guard !text.isEmpty else {return}
        DispatchQueue.main.async {
            self.labelCounter.text = text
        }
    }
    
    func showDeniedSpeechAuthorizeAlert(){
        let alert = UIAlertController(title: "ありがとうアプリ", message: "マイクの使用許可がないためアプリを終了します。\nアプリをはじめるには「設定」→「ありがとうアプリ」→音声認識をONにしてください。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

