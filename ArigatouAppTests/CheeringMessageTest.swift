//
//  CheeringMessageTest.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/10/14.
//

import XCTest
@testable import ArigatouApp


class CheeringMessageTest: XCTestCase {
    func testGetMessage(){
        var message = ""
        message = CheeringMessage.shared.getMessage(achievementRate: 10.0)
        XCTAssertTrue(["ご自身のペースで続けてくださいね♪", "焦らずゆっくり♫", "無理せずいきましょう♫", "大きな成果への第一歩です！"].contains(message))
        
        message = CheeringMessage.shared.getMessage(achievementRate: 30.0)
        XCTAssertTrue(["いい調子です♪", "挑戦が素晴らしいです♫", "毎日の積み重ねが大事ですね！", "順調に進んでいます！"].contains(message))

        message = CheeringMessage.shared.getMessage(achievementRate: 70.0)
        XCTAssertTrue(["達成まで目前ですね！", "今日も沢山ありがとうございます！", "とても良いペースです♫", "あと少し！焦らずゆっくり♫"].contains(message))
        
        message = CheeringMessage.shared.getMessage(achievementRate: 90.0)
        XCTAssertTrue(["今日の目標達成まであと少しです♪", "あと一歩で達成ですね！", "最後まで楽しんでいきましょう♪", "あと少し！"].contains(message))
        
        message = CheeringMessage.shared.getMessage(achievementRate: 100.0)
        XCTAssertTrue(["あなたを誇りに思います！", "今日の達成おめでとうございます♪", "素晴らしいです！", "沢山のありがとうをありがとう"].contains(message))
        
    }
}
