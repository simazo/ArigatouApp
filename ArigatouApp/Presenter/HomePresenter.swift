//
//  HomePresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import Speech
import Firebase

protocol HomePresenterInput: AnyObject {
    func viewDidLoad()
    func viewWillAppear()
    func logout()
    func deleteAccount()
}

protocol HomePresenterOutput: AnyObject {
    func showStartScreen()
    func showEndScreen()
    func showDeniedSpeechAuthorizeAlert()
    func redrawRemainingLabel(text: String)
    func redrawCounterLabel(text: String)
    func redrawTodayCountLabel(text: String)
    func startMicAnimating()
    func playVideo(url: String)
    func showPlayVideoListMenu(menus: [String])
    func showLoginMenu()
    func showPreLoginMenu()
    func showLogoutFailure(errorMessage: String)
    func showDeleteAccountFailure(errorMessage: String)
}

class HomePresenter{
    private weak var view: HomePresenterOutput?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    
    private let MATCH_WORD = "ありがと|ありがとう"
    private let MAX_COUNT = 1000000
    private var previousTranscription = ""
    
    private let dateManager = DateManager.shared
    private let factory = CounterFactory()
    private var totalCounter: Counter!
    private var dailyCounter: Counter!
    private var weeklyCounter: Counter!
    private var monthlyCounter: Counter!
    
    private var isRestarting = false
    
    init(view: HomePresenterOutput) {
        self.view = view
        
        totalCounter = factory.create(type: .total)
        dailyCounter = factory.create(type: .daily)
        weeklyCounter = factory.create(type: .weekly)
        monthlyCounter = factory.create(type: .monthly)
        
        // UserDefaults debug
        // print(UserDefaults.standard.dictionaryRepresentation())

        // UserDefaults clear
        /*
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
        */
    }
    
    private func incrementCount() {
        totalCounter.incrementCount()
        dailyCounter.incrementCount(for: dateManager.formattedDateString())
        weeklyCounter.incrementCount(for: dateManager.formattedWeekString())
        monthlyCounter.incrementCount(for: dateManager.formattedMonthString())
    }
    
    /// マイク使用許可の確認
    func isAuthorized(completion: @escaping (Bool) -> Void){
        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            guard let self = self else {
                completion(false)
                return
            }
            DispatchQueue.main.async {
                if status == .authorized && self.speechRecognizer.isAvailable {
                    completion(true)
                }else {
                    completion(false)
                }
            }
        }
    }
    
    func startSpeech() throws {
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: [])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        // オンデバイス音声認識
        if self.speechRecognizer.supportsOnDeviceRecognition {
            self.recognitionRequest?.requiresOnDeviceRecognition = true
        }
        
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = recognitionRequest
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let result = result {
              
                let currentTranscription = result.bestTranscription.formattedString
                
                // 前回の認識結果と比較して重複を削除
                let filteredTranscription = self.filterDuplicate(previous: self.previousTranscription, current: currentTranscription)
                
                // 結果を表示
                //print(filteredTranscription)

                self.previousTranscription = currentTranscription
                self.view?.startMicAnimating()
                
                // マッチした場合
                if let _ = filteredTranscription.range(of: MATCH_WORD, options: .regularExpression) {

                    // カウントアップ
                    self.incrementCount()

                    // 動画再生
                    playVideoIfMatchCountReached(totalCounter.getCount())
                    
                    // ラベル再描画
                    self.view?.redrawRemainingLabel(text: "「ありがとう100万回」\n\n達成まであと\n\n\(self.formatRemainingCount())回")
                    
                    self.view?.redrawCounterLabel(text: "\(self.formatTotalCount())回目のありがとう")
                    
                    self.view?.redrawTodayCountLabel(text: "本日\(self.formatTodayCount())回\n\n合計\(self.formatTotalCount())回")
                    
                    // タイムラグ挿入
                    //Thread.sleep(forTimeInterval: 0.5)
                    
                    // 音声認識リスタート
                    self.restartSpeech()
                }
            }
        }
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 2048, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("Audio engine start error: \(error.localizedDescription)")
            throw error
        }
    }
    
    func filterDuplicate(previous: String, current: String) -> String {
        if previous.isEmpty {
            return current
        }
        
        if current == previous {
            return ""
        }
        
        return current
    }
    
    func stopSpeech() {
        if let task = self.recognitionTask {
            task.cancel()
            task.finish()
            self.recognitionTask = nil
        }
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionRequest?.endAudio()
        self.recognitionRequest = nil
    }
    
    private func restartSpeech() {
        guard !isRestarting else { return }
        isRestarting = true
        self.stopSpeech()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            do {
                try self.startSpeech()
            } catch {
                print("restartSpeech Error: \(error)")
            }
            self.isRestarting = false
        }
    }
    
    private func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.restartSpeech()
        }
    }
    
    private func formatRemainingCount() -> String {
        return String.localizedStringWithFormat("%d", 1000000 - totalCounter.getCount())
    }
    
    private func formatTodayCount() -> String {
        return String.localizedStringWithFormat(
            "%d",
            dailyCounter.getCount(for: dateManager.formattedDateString())
        )
    }
    
    private func formatTotalCount() -> String {
        return String.localizedStringWithFormat("%d", totalCounter.getCount())
    }
    
    private func playVideoIfMatchCountReached(_ match_count: Int) {
        // 特定のマッチ数ではない場合処理を抜ける
        guard let videoURL = VideoList.shared.getUrlByCount(match_count) else {
            return
        }
        
        // ネットワーク接続ある場合は動画再生
        if (NetworkManager.isConnectedToNetwork()) {
            self.view?.playVideo(url: videoURL)
        }
        
        // 再生リスト表示
        view?.showPlayVideoListMenu(menus: VideoList.shared.getMatchMenus(matchCount: match_count))
    }
}

extension HomePresenter: HomePresenterInput {

    func viewWillAppear() {
        // ログイン済みかどうかでナビメニュー変更
        AuthManager.shared.isLoggedIn { (isAuthenticated, uid) in
            if isAuthenticated {
                view?.showLoginMenu()
            } else {
                view?.showPreLoginMenu()
            }
        }
        // ラベル更新
        self.view?.redrawRemainingLabel(text: "「ありがとう100万回」\n\n達成まであと\n\n\(self.formatRemainingCount())回")
        
        self.view?.redrawTodayCountLabel(text: "本日\(self.formatTodayCount())回\n\n合計\(self.formatTotalCount())回")
    }

    func viewDidLoad() {
        let shouldShowEndScreen = totalCounter.getCount() >= MAX_COUNT
        
        // 100万回達していれば
        if shouldShowEndScreen {
            // 終了画面を表示
            view?.showEndScreen()
        }
        else {
            // 通常画面を表示
            view?.showStartScreen()
            
            // マイクの使用許可確認
            handleAuthorizationStatus()
        }
        
        // 動画の再生リスト表示
        view?.showPlayVideoListMenu(menus: VideoList.shared.getMatchMenus(matchCount: totalCounter.getCount()))
    }
    
    func handleAuthorizationStatus() {
        isAuthorized { [weak self] (isAuthorized) in
            guard let self = self else { return }
            if isAuthorized {
                do {
                    try self.startSpeech()
                } catch {
                    print("startSpeech Error: \(error)")
                }
                self.startTimer()
            } else {
                // 起動時に１回表示
                self.view?.showDeniedSpeechAuthorizeAlert()
                
                // その後は５秒おきにアラート表示
                Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                    self.view?.showDeniedSpeechAuthorizeAlert()
                }
            }
        }
        // ラベル更新
        self.view?.redrawRemainingLabel(text: "「ありがとう100万回」\n\n達成まであと\n\n\(self.formatRemainingCount())回")
        
        self.view?.redrawTodayCountLabel(text: "本日\(self.formatTodayCount())回\n\n合計\(self.formatTotalCount())回")
    }
    
    func logout() {
        AuthManager.shared.logout { [weak self] success, error in
            guard let self = self else { return }
            
            // ログアウト成功
            if success {
                self.view?.showPreLoginMenu()
                return
            }
            
            // ログアウト失敗
            if let error = error as NSError? {
                let errorMessage: String
                
                switch error.code {
                case AuthErrorCode.networkError.rawValue:
                    errorMessage = "ネットワークエラーが発生しました。接続を確認してください。"
                case AuthErrorCode.userTokenExpired.rawValue:
                    errorMessage = "認証トークンの期限が切れています。再ログインしてください。"
                case AuthErrorCode.userNotFound.rawValue:
                    errorMessage = "ユーザーが見つかりません。"
                case AuthErrorCode.invalidUserToken.rawValue:
                    errorMessage = "無効なユーザートークンです。"
                case AuthErrorCode.invalidCredential.rawValue:
                    errorMessage = "提供された認証情報が不正か期限切れです。"
                case AuthErrorCode.userDisabled.rawValue:
                    errorMessage = "このアカウントは無効化されています。"
                case AuthErrorCode.tooManyRequests.rawValue:
                    errorMessage = "リクエストが多すぎます。後でもう一度お試しください。"
                default:
                    errorMessage = error.localizedDescription
                }
                self.view?.showLogoutFailure(errorMessage: errorMessage)
            } else {
                self.view?.showLogoutFailure(errorMessage: "ログアウトエラー")
            }
        }
    }
    
    func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            self.view?.showDeleteAccountFailure(errorMessage: "ユーザーが見つかりません。")
            return
        }
        
        user.delete { [weak self] error in
            guard let self = self else { return }
            
            // 退会成功
            if error == nil {
                self.view?.showPreLoginMenu()
                return
            }
            
            // 退会失敗
            if let error = error as NSError? {
                let errorMessage: String
                
                switch error.code {
                case AuthErrorCode.networkError.rawValue:
                    errorMessage = "ネットワークエラーが発生しました。接続を確認してください。"
                case AuthErrorCode.userTokenExpired.rawValue:
                    errorMessage = "認証トークンの期限が切れています。再ログインしてください。"
                case AuthErrorCode.userNotFound.rawValue:
                    errorMessage = "ユーザーが見つかりません。"
                case AuthErrorCode.invalidUserToken.rawValue:
                    errorMessage = "無効なユーザートークンです。"
                case AuthErrorCode.invalidCredential.rawValue:
                    errorMessage = "提供された認証情報が不正か期限切れです。"
                case AuthErrorCode.requiresRecentLogin.rawValue:
                    errorMessage = "再認証が必要です。再度ログインしてからもう一度お試しください。"
                case AuthErrorCode.userDisabled.rawValue:
                    errorMessage = "このアカウントは無効化されています。"
                case AuthErrorCode.tooManyRequests.rawValue:
                    errorMessage = "リクエストが多すぎます。後でもう一度お試しください。"
                default:
                    errorMessage = error.localizedDescription
                }
                self.view?.showDeleteAccountFailure(errorMessage: errorMessage)
            } else {
                self.view?.showDeleteAccountFailure(errorMessage: "退会エラー")
            }
        }
    }
    
}

