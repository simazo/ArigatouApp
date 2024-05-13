//
//  HomeViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import UIKit
import AVKit

class HomeViewController: UIViewController {
    private var remainingLabel: UILabel!
    private var counterLabel: UILabel!
    private var micView: MicImageView!
    
    var naviMenutableView: NaviMenuTableView!
    var isMenuVisible = false
    let items = ["ログイン", "アカウント登録"]
    
    private var presenter: HomePresenterInput!
    
    var timer: Timer = Timer()
    var count: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigation()
        initGesture()
        initBackground(name: "cosmos-1920.jpg")
        
        presenter = HomePresenter(view: self)
        presenter.viewDidLoad()
    }
    
    func initGesture() {
        // タップジェスチャーの追加
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // メニューのタップを処理するために、cancelsTouchesInView を false に設定する
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isMenuVisible {
            // タップされた場所がメニュー内であれば、メニューのタップを処理し、
            // それ以外の場所のタップを無視する
            let location = sender.location(in: naviMenutableView)
            if naviMenutableView.bounds.contains(location) {
                return
            }
        }
        
        // メニュー以外の場所がタップされた場合の処理
        isMenuVisible = false
        naviMenutableView.isHidden = true
    }

    func initNavigation(){
        self.title = ""
        let barButton = UIBarButtonItem(title: "", image: UIImage(systemName: "person.fill"), target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = barButton
        
        // 次の画面のBackボタンを「戻る」に変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:  "戻る", style:  .plain, target: nil, action: nil)
        
        naviMenutableView = NaviMenuTableView(frame: CGRect.zero, style: .plain)
        naviMenutableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(naviMenutableView)
        
        NSLayoutConstraint.activate([
            naviMenutableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            naviMenutableView.heightAnchor.constraint(equalToConstant: 200),
            naviMenutableView.topAnchor.constraint(equalTo: view.topAnchor),
            naviMenutableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        naviMenutableView.isHidden = true
        naviMenutableView.items = items
        naviMenutableView.menuDelegate = self
    }
    
    @objc func addButtonTapped(){
        isMenuVisible.toggle()
        naviMenutableView.isHidden = !isMenuVisible
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
        micView = MicImageView(image: UIImage(systemName: "mic.fill"))
        micView.tintColor = .orange // アイコンの色をオレンジに設定
        micView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(micView)
        
        NSLayoutConstraint.activate([
            micView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 110.0),
            micView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            micView.widthAnchor.constraint(equalToConstant: 50),
            micView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func startMicAnimating(){
        
        // 1.2秒後にアニメーションを停止する
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            self.micView.stopBounceAnimation()
        }
        
        // アニメーションを開始する
        DispatchQueue.main.async {
            self.micView.startBounceAnimation()
        }
    }
}
extension HomeViewController: NaviMenuTableViewDelegate{
    func didSelectItem(_ item: String) {
        
        // 項目をタップしても、ナビがそのまま残るのでタップのタイミングで非表示に
        naviMenutableView.isHidden = true
        isMenuVisible = false
        
        switch item {
        case "ログイン":
            let secondVC = LoginViewController()
            self.navigationController?.pushViewController(secondVC, animated: true)
        case "アカウント登録":
            print("アカウント登録へ")
        default:
            break
        }
    }
}
extension HomeViewController: HomePresenterOutput{
    
    func playMovie(url: String) {
        let url = URL(string: url)!
        let player = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.exitsFullScreenWhenPlaybackEnds = true
        playerViewController.player = player
        DispatchQueue.main.async {
            self.present(playerViewController, animated: true) {
                player.play()
            }
        }
    }
    
    
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

