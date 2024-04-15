//
//  ViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import UIKit

class ViewController: UIViewController {
    private var counterLabel: PaddingLabel!
    private var micImageView: UIImageView!
    private var micImages: [UIImage]!
    
    private var presenter: PresenterInput!
    
    var timer: Timer = Timer()
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initCounterLabel()
        initMicImage()
        presenter = SpeechPresenter(view: self)
        presenter.viewDidLoad()
        
    }
    
    func initCounterLabel(){
        counterLabel = PaddingLabel(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
        counterLabel.text = "現在、\n0回"
        counterLabel.font = .systemFont(ofSize: 20)
        counterLabel.backgroundColor = UIColor.systemOrange
        counterLabel.textColor = .white
        counterLabel.textAlignment = .center
        counterLabel.numberOfLines = 0
        // 角丸に変更
        counterLabel.layer.cornerRadius = 15
        counterLabel.clipsToBounds = true
        
        // 中央に配置
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(counterLabel)
        NSLayoutConstraint.activate([
            counterLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            counterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func initMicImage(){
        micImageView = UIImageView()
        micImages = [UIImage]()
        
        // 配置
        micImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(micImageView)
        NSLayoutConstraint.activate([
            micImageView.centerYAnchor.constraint(equalTo: counterLabel.bottomAnchor, constant: 50.0),
            micImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        // アニメーション設定
        for i in 1...2 {
            micImages.append(UIImage(named: "mic\(i).png")!)
        }
        micImageView.animationImages = micImages
        micImageView.animationDuration = 0.1
        micImageView.image = UIImage(named: "mic1")
    }
    
    func startMicAnimating(){
        guard !micImageView.isAnimating else {
            return
        }
        
        micImageView.startAnimating()
        
        DispatchQueue.global(qos: .default).async {
           
            // アニメーション１回分の時間
            Thread.sleep(forTimeInterval: 1.2)
            
            // メインスレッドでアニメーション終了させる
            DispatchQueue.main.async {
                self.micImageView.stopAnimating()
            }
        }
    }
}
extension ViewController: PresenterOutput{
    func refreshCounterLabel(text: String) {
        guard !text.isEmpty else {return}
        DispatchQueue.main.async {
            self.counterLabel.text = text
        }
    }
    
    func showDeniedSpeechAuthorizeAlert(){
        let alert = UIAlertController(title: "ありがとうアプリ", message: "マイクの使用許可がないためアプリを終了します。\nアプリをはじめるには「設定」→「ありがとうアプリ」→音声認識をONにしてください。", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

