//
//  CheeringMessage.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/13.
//

import Foundation

class CheeringMessage {
    static let shared = CheeringMessage()
    private init() {}
    
    // 非常に低: 0〜20%
    private let veryLow = [
        "ご自身のペースで続けてくださいね♪",
        "焦らずゆっくり♫",
        "無理せずいきましょう♫",
        "大きな成果への第一歩です！"
    ]
    
    // 低: 21〜40%
    private let low = [
        "いい調子です♪",
        "挑戦が素晴らしいです♫",
        "毎日の積み重ねが大事ですね！",
        "順調に進んでいます！"
    ]
    
    // 中: 41〜60%
    private let medium = [
        "目標の半分まで来ました！",
        "ここまで来た自分を褒めてください♫",
        "ご自身のペースで大丈夫！",
        "すごい！もう半分です！"
    ]
    
    
    // 高: 61〜80%
    private let high = [
        "達成まで目前ですね！",
        "今日も沢山ありがとうございます！",
        "とても良いペースです♫",
        "あと少し！焦らずゆっくり♫"
    ]
    
    // 非常に高: 81〜99%
    private let veryHight = [
        "今日の目標達成まであと少しです♪",
        "あと一歩で達成ですね！",
        "最後まで楽しんでいきましょう♪",
        "あと少し！"
    ]

    // 達成: 100%〜
    private let full = [
        "あなたを誇りに思います！",
        "今日の達成おめでとうございます♪",
        "素晴らしいです！",
        "沢山のありがとうをありがとう"
    ]
    

    func getMessage(achievementRate: Double) -> String {
        switch achievementRate {
        case 0.0...20.0:
            return randomMessage(messages: veryLow)
        case 20.01...40.0:
            return randomMessage(messages: low)
        case 40.01...60.0:
            return randomMessage(messages: medium)
        case 60.01...80.0:
            return randomMessage(messages: high)
        case 80.01...99.99:
            return randomMessage(messages: veryHight)
        case 100.0:
            return randomMessage(messages: full)
        default:
            return ""
        }
    }
    
    private func randomMessage(messages: [String]) -> String {
        if let message = messages.randomElement() {
            return message
        }
        return ""
    }
    
}
