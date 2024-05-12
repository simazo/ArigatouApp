//
//  HomePresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import Speech

protocol HomePresenterInput: AnyObject {
    func viewDidLoad()
}

protocol HomePresenterOutput: AnyObject {
    func showStartScreen()
    func showEndScreen()
    func showDeniedSpeechAuthorizeAlert()
    func redrawRemainingLabel(text: String)
    func redrawCounterLabel(text: String)
    func startMicAnimating()
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
    var matchCountManger: MatchCountManager!
    
    init(view: HomePresenterOutput) {
        self.view = view
        self.matchCountManger = MatchCountManager(UserDefaultsMatchCountRepository())
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
                print(filteredTranscription)

                self.previousTranscription = currentTranscription
                self.view?.startMicAnimating()
                
                // マッチした場合
                if let _ = filteredTranscription.range(of: MATCH_WORD, options: .regularExpression) {

                    // カウントアップ
                    self.matchCountManger.incrementCount()

                    // ラベル再描画
                    self.view?.redrawRemainingLabel(text: "「ありがとう100万回」\n\n達成まで\n\nあと\(self.formatRemainingCount())回")
                    
                    self.view?.redrawCounterLabel(text: "\(self.formatTotalCount())回目のありがとう")
                    
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
        
        audioEngine.prepare()
        try? audioEngine.start()
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
        guard let task = self.recognitionTask else {
            fatalError("Error")
        }
        task.cancel()
        task.finish()
        
        self.audioEngine.inputNode.removeTap(onBus: 0)
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
    }
    
    private func restartSpeech() {
        self.stopSpeech()
        do {
            try self.startSpeech()
        } catch {
            print("startError: \(error)")
        }
    }
    
    private func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.restartSpeech()
        }
    }
    
    private func formatRemainingCount() -> String {
        return String.localizedStringWithFormat("%d", 1000000 - self.matchCountManger.getCount())
    }
    
    private func formatTotalCount() -> String {
        return String.localizedStringWithFormat("%d", self.matchCountManger.getCount())
    }
}

extension HomePresenter: HomePresenterInput {
    
    func viewDidLoad() {
        let shouldShowEndScreen = matchCountManger.getCount() >= MAX_COUNT
        
        if shouldShowEndScreen {
            view?.showEndScreen()
        }
        else {
            view?.showStartScreen()
            handleAuthorizationStatus()
        }
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
        self.view?.redrawRemainingLabel(text: "「ありがとう100万回」\n\n達成まで\n\nあと\(self.formatRemainingCount())回")
    }
}

