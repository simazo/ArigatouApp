//
//  HomeViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import UIKit

class HomeViewController: UIViewController {
    private var remainingLabel: UILabel!
    private var counterLabel: UILabel!
    private var micImageView: UIImageView!
    private var micImages: [UIImage]!
    
    private var presenter: PresenterInput!
    
    var timer: Timer = Timer()
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        initBackground(name: "cosmos-1920.jpg")
        
        presenter = HomePresenter(view: self)
        presenter.viewDidLoad()
        
    }
    
    func initNavigation(){
        self.title = "ありがとう100万回"
        let barButton = UIBarButtonItem(title: "", image: UIImage(systemName: "person.fill"), target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = barButton
        
        // 次の画面のBackボタンを「戻る」に変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:  "戻る", style:  .plain, target: nil, action: nil)
    }
    
    @objc func addButtonTapped(){
        let secondVC = LoginViewController()
        self.navigationController?.pushViewController(secondVC, animated: true)
    }
    
    func initBackground(name: String){
        // imageViewの生成
        let imageViewBackground = UIImageView()
        imageViewBackground.translatesAutoresizingMaskIntoConstraints = false
        imageViewBackground.image = UIImage(named: name)
        imageViewBackground.contentMode = .scaleAspectFill
        
        // imageViewを追加
        self.view.addSubview(imageViewBackground)
        
        // Auto Layout制約を追加
        NSLayoutConstraint.activate([
            imageViewBackground.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            imageViewBackground.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            imageViewBackground.topAnchor.constraint(equalTo: self.view.topAnchor),
            imageViewBackground.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        // 加えたsubviewを、最背面に設置する
        self.view.sendSubviewToBack(imageViewBackground)
    }
    
    func initRemainingLabel(){
        remainingLabel = UILabel()
        remainingLabel.font = .boldSystemFont(ofSize: 20)
        remainingLabel.backgroundColor = UIColor.clear
        remainingLabel.textColor = .white
        remainingLabel.textAlignment = .center
        remainingLabel.numberOfLines = 0
        
        // 中央に配置
        remainingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(remainingLabel)
        NSLayoutConstraint.activate([
            remainingLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            remainingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func initCounterLabel(){
        counterLabel = UILabel()
        counterLabel.font = .boldSystemFont(ofSize: 28)
        counterLabel.backgroundColor = UIColor.clear
        counterLabel.textColor = .yellow
        counterLabel.textAlignment = .center
        counterLabel.numberOfLines = 0
        
        // 中央に配置
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(counterLabel)
        NSLayoutConstraint.activate([
            counterLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            counterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        counterLabel.alpha = 0
    }
    
    func initMicImage(){
        micImageView = UIImageView()
        micImages = [UIImage]()
        
        // 配置
        micImageView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(micImageView)
        NSLayoutConstraint.activate([
            micImageView.centerYAnchor.constraint(equalTo: remainingLabel.bottomAnchor, constant: 50.0),
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
extension HomeViewController: PresenterOutput{
    
    func showStartScreen() {
        initRemainingLabel()
        initCounterLabel()
        initMicImage()
    }
    
    func showEndScreen() {
        initRemainingLabel()
        remainingLabel.text = "「ありがとう100万回」\n\n本当におめでとうございます\n\n最後までありがとうございました\n\nあなたとあなたの周りに\n\n沢山の幸せが訪れますように"
    }
    
    func redrawRemainingLabel(text: String) {
        guard !text.isEmpty else {return}
        DispatchQueue.main.async {
            self.remainingLabel.text = text
        }
    }
    
    func redrawCounterLabel(text: String) {
        guard !text.isEmpty else {return}
        DispatchQueue.main.async {
            self.remainingLabel.isHidden = true
            self.counterLabel.text = text
            self.counterLabel.alpha = 1
            UIView.animate(withDuration: 1.4, delay: 0, options: .curveEaseIn) {
                self.counterLabel.alpha = 0
            } completion: { (_) in
                //print("フェードアウト終了")
                self.remainingLabel.isHidden = false
            }
        }
        
    }
    
    func showDeniedSpeechAuthorizeAlert(){
        let alert = UIAlertController(title: "ありがとう100万回", message: "開始するにはマイクと音声認識へのアクセスを許可してください。", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "キャンセル", style: .default)
        alert.addAction(cancel)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        alert.addAction(ok)
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
