//
//  SpeechPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import Speech

protocol PresenterInput: AnyObject {
    func viewDidLoad()
}

protocol PresenterOutput: AnyObject {
    func refreshLabelText(text: String)
    func showDeniedSpeechAuthorizeAlert()
}

final class SpeechPresenter{
    private weak var view: PresenterOutput?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "ja-JP"))!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    
    private let WORD = "ありがと"
    private var hit_count = 0
    
    init(view: PresenterOutput) {
        self.view = view
    }
    
    func checkAuthorize() {
        SFSpeechRecognizer.requestAuthorization { [weak self] (status) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                if status == .authorized && self.speechRecognizer.isAvailable {
                    do {
                        try self.startSpeech()
                    } catch {
                        print("startSpeech Error: \(error)")
                    }
                    self.startTimer()
                } else {
                    self.view?.showDeniedSpeechAuthorizeAlert()
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
        
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        self.recognitionRequest = recognitionRequest
        recognitionRequest.shouldReportPartialResults = true
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] (result, error) in
            guard let self = self else { return }
            
            if let result = result {
                print(result.bestTranscription.formattedString)
                self.view?.refreshLabelText(text: self.countResult(result.bestTranscription.formattedString))
                
            }
        }
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try? audioEngine.start()
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
    
    private func countResult(_ result: String) -> String {
        if result.contains(WORD) {
            stopSpeech()
            do {
                try startSpeech()
            } catch {
                print("startSpeech Error: \(error)")
            }
            hit_count += 1
            return "現在、\n\(hit_count)回"
        } else {
            return ""
        }
    }
    
    func startTimer(){
        Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
            self.stopSpeech()
            do {
                try self.startSpeech()
            } catch{
                print("startSpeech Error: \(error)")
            }
        }
    }
}

extension SpeechPresenter: PresenterInput {
    func viewDidLoad() {
        checkAuthorize()
    }
}

