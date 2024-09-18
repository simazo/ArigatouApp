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
    
    var naviMenutableViewForPerson: NaviMenuTableView!
    var naviMenutableViewForPlayVideo: NaviMenuTableView!
    var isPersonMenuVisible = false
    var isPlayVideoMenuVisible = false
    
    private var presenter: HomePresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initBackground(name: "cosmos-1920.jpg")
        
        initNavigation()
        initPersonAndChartMenu()
        initGesture()
        
        presenter = HomePresenter(view: self)
        presenter.viewDidLoad()
        
        // UserDefaults debug
        //print(UserDefaults.standard.dictionaryRepresentation())

        // UserDefaults clear
        /*
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        */

    }
    
    // ログインページから戻ってきた場合など、このViewControllerがアクティブになった時
    override func viewWillAppear(_ animated: Bool) {
    
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // タップジェスチャーの追加
    private func initGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        // メニューのタップを処理するために、cancelsTouchesInView を false に設定する
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isPersonMenuVisible {
            // タップされた場所がメニュー内であれば、メニューのタップを処理し、
            // それ以外の場所のタップを無視する
            let location = sender.location(in: naviMenutableViewForPerson)
            if naviMenutableViewForPerson.bounds.contains(location) {
                return
            }
        } else if isPlayVideoMenuVisible {
            let location = sender.location(in: naviMenutableViewForPlayVideo)
            if naviMenutableViewForPlayVideo.bounds.contains(location) {
                return
            }
        }
        
        // メニュー以外の場所がタップされた場合の処理
        isPersonMenuVisible = false
        naviMenutableViewForPerson.isHidden = true
        
        if naviMenutableViewForPlayVideo != nil {
            isPlayVideoMenuVisible = false
            naviMenutableViewForPlayVideo.isHidden = true
        }
    }

    private func initNavigation(){
        self.title = ""
        
        // 次の画面のBackボタンを「戻る」に変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:  "戻る", style:  .plain, target: nil, action: nil)
    }
    
    private func initPersonAndChartMenu() {
        let personButton: UIBarButtonItem
        let chartButton: UIBarButtonItem
        
        if #available(iOS 16.0, *) {
            personButton = UIBarButtonItem(title: "", 
                                           image: UIImage(systemName: "person"),
                                           target: self,
                                           action: #selector(personButtonTapped))
            chartButton = UIBarButtonItem(title: "", 
                                          image: UIImage(systemName: "chart.line.uptrend.xyaxis"),
                                          target: self,
                                          action: #selector(chartButtonTapped))
        } else {
            personButton = UIBarButtonItem(image: UIImage(systemName: "person"), 
                                           style: .plain,
                                           target: self,
                                           action: #selector(personButtonTapped))
            chartButton = UIBarButtonItem(image: UIImage(systemName: "chart.line.uptrend.xyaxis"), 
                                          style: .plain,
                                          target: self,
                                          action: #selector(chartButtonTapped))
            
        }
        
        navigationItem.rightBarButtonItems = [personButton, chartButton]
        
        naviMenutableViewForPerson = NaviMenuTableView(frame: CGRect.zero, style: .plain)
        naviMenutableViewForPerson.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(naviMenutableViewForPerson)
        
        NSLayoutConstraint.activate([
            naviMenutableViewForPerson.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            naviMenutableViewForPerson.heightAnchor.constraint(equalToConstant: 240),
            naviMenutableViewForPerson.topAnchor.constraint(equalTo: view.topAnchor),
            naviMenutableViewForPerson.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        naviMenutableViewForPerson.isHidden = true
        naviMenutableViewForPerson.items = ["ログイン", "アカウント登録"]
        naviMenutableViewForPerson.menuDelegate = self
        
    }
    
    private func initPlayVideoMenu(menus: [String]) {
        if #available(iOS 16.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", 
                                                               image: UIImage(systemName: "play.fill"), 
                                                               target: self,
                                                               action: #selector(playVideoButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "play.fill"), 
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(personButtonTapped))
        }
        
        naviMenutableViewForPlayVideo = NaviMenuTableView(frame: CGRect.zero, style: .plain)
        naviMenutableViewForPlayVideo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(naviMenutableViewForPlayVideo)
        
        // メニュー数によって高さ調整
        let initialHeight: CGFloat = 140 // 高さの基準値
        let adjustedHeight = max(initialHeight - CGFloat(10 * (menus.count - 1)), 60) //１増えるごとに基準値を10減少
            
        NSLayoutConstraint.activate([
            naviMenutableViewForPlayVideo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.4),
            naviMenutableViewForPlayVideo.heightAnchor.constraint(equalToConstant: CGFloat(CGFloat(menus.count) * adjustedHeight)),
            naviMenutableViewForPlayVideo.topAnchor.constraint(equalTo: view.topAnchor),
            naviMenutableViewForPlayVideo.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
        naviMenutableViewForPlayVideo.isHidden = true
        naviMenutableViewForPlayVideo.items = menus
        naviMenutableViewForPlayVideo.menuDelegate = self
        
    }
    
    private func deinitPlayVideoMenu() {

        navigationItem.leftBarButtonItem = nil
        
        // 生成されている場合にのみ削除する
        guard let naviMenuTableView = naviMenutableViewForPlayVideo else {
            return
        }
        
        // 画面から削除
        naviMenuTableView.removeFromSuperview()
    }

    @objc func personButtonTapped(){
        isPersonMenuVisible.toggle()
        naviMenutableViewForPerson.isHidden = !isPersonMenuVisible
    }
    
    @objc func chartButtonTapped() {
        self.navigationController?.pushViewController(TodayRecordViewController(), animated: true)
    }
    
    @objc func playVideoButtonTapped() {
        isPlayVideoMenuVisible.toggle()
        naviMenutableViewForPlayVideo.isHidden = !isPlayVideoMenuVisible
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            remainingLabel.font = .boldSystemFont(ofSize: 44)
        } else {
            remainingLabel.font = .boldSystemFont(ofSize: 20)
        }
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
        if UIDevice.current.userInterfaceIdiom == .pad {
            counterLabel.font = .boldSystemFont(ofSize: 54)
        } else {
            counterLabel.font = .boldSystemFont(ofSize: 28)
        }
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
        
        var position: CGFloat = 0.0
        var size: CGFloat = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            position = 200
            size = 80
        } else {
            position = 110
            size = 40
        }
        
        NSLayoutConstraint.activate([
            micView.centerYAnchor.constraint(equalTo: remainingLabel.centerYAnchor, constant: position),
            micView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            micView.widthAnchor.constraint(equalToConstant: size),
            micView.heightAnchor.constraint(equalToConstant: size)
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
        naviMenutableViewForPerson.isHidden = true
        isPersonMenuVisible = false
        
        if naviMenutableViewForPlayVideo != nil {
            naviMenutableViewForPlayVideo.isHidden = true
            isPlayVideoMenuVisible = false
        }
        
        switch item {
        case "ログイン":
            self.navigationController?.pushViewController(LoginViewController(), animated: true)
        case "アカウント登録":
            self.navigationController?.pushViewController(SignupViewController(), animated: true)
        case "ログアウト":
            showLogoutAlert()
        case "退会":
            showDeleteAccountAlert()
        case "同期":
            self.navigationController?.pushViewController(SynchronizedViewController(), animated: true)
        case let x where x.contains("回目の動画"):
            playVideo(url: VideoList.shared.getUrlByMenu(item)!)
        default:
            break
        }
    }
    
    private func showLogoutAlert() {
        let alertController = UIAlertController(title: "ログアウト", message: "ログアウトしますか？", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "ログアウト", style: .default) { (_) in
            self.presenter.logout()
        }
        alertController.addAction(okAction)
    
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func showDeleteAccountAlert() {
        let alertController = UIAlertController(title: "退会しますか？", message: "退会するとカウント数はクラウドに保存できなくなりますが、アプリはそのままご利用いただけます。", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "退会する", style: .default) { (_) in
            self.presenter.deleteAccount()
        }
        alertController.addAction(okAction)
    
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
extension HomeViewController: HomePresenterOutput{
    func showLoginMenu() {
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "person.fill"), target: self, action: #selector(personButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(personButtonTapped))
        }
        naviMenutableViewForPerson.items = ["同期", "ログアウト", "退会"]
    }
    
    func showPreLoginMenu() {
        if #available(iOS 16.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "person"), target: self, action: #selector(personButtonTapped))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(personButtonTapped))
        }
        naviMenutableViewForPerson.items = ["ログイン", "アカウント登録"]
    }
    
    func showLogoutFailure(errorMessage: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "ログアウトエラー", message: errorMessage)
        }
    }
    
    func showDeleteAccountFailure(errorMessage: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "退会エラー", message: errorMessage)
        }
    }
    
    func showPlayVideoListMenu(menus: [String]) {
        // 初期化
        deinitPlayVideoMenu()
        
        guard !menus.isEmpty else {
            return
        }
        // 生成
        initPlayVideoMenu(menus: menus)
    }
    
    func playVideo(url: String) {
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
        let alert = UIAlertController(title: "ありがとう100万回", message: """
                                      開始するにはマイクと音声認識へのアクセスを許可してください。
                                      
                                      このアプリは音声認識を使用して、音声をリアルタイムで処理します。
                                      
                                      音声データはリクエストの処理と音声認識技術の向上のためにAppleに送信されますが、音声データは匿名化され、個人情報は含まず、保存されることもありません。
                                      """,
                                      preferredStyle: .alert)
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

