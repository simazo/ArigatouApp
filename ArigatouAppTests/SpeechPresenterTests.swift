//
//  ArigatouAppTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/04/16.
//

import XCTest
@testable import ArigatouApp

class MockPresenterOutput: PresenterOutput {
    
    var startScreenShown = false
    func showStartScreen() {
        startScreenShown = true
    }
    
    var endScreenShown = false
    func showEndScreen() {
        endScreenShown = true
    }
    
    func redrawRemainingLabel(text: String) {}
    
    func redrawCounterLabel(text: String) {}
    

    var deniedSpeechAuthorizeAlertShown = false
    func showDeniedSpeechAuthorizeAlert() {
        deniedSpeechAuthorizeAlertShown = true
    }
    
    func startMicAnimating() {}
}

class MockSpeechPresenter: SpeechPresenter {
    var authorized: Bool = true // デフォルトは許可状態
    
    override func isAuthorized(completion: @escaping (Bool) -> Void) {
        completion(authorized)
    }
}

class SpeechPresenterTests: XCTestCase {
    
    var presenter: MockSpeechPresenter!
    var mockView: MockPresenterOutput!

    override func setUp() {
        super.setUp()
        mockView = MockPresenterOutput()
        presenter = MockSpeechPresenter(view: mockView)
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        super.tearDown()
    }
    
    // マイク使用許可が与えられている場合、許可確認アラートが表示されないことをテスト
    func testSpeechAuthorization() {
        
        // 許可に設定
        presenter.authorized = true
        
        // viewDidLoad() を呼び出す
        presenter.viewDidLoad()
        
        // アラートが表示されないことを確認
        XCTAssertFalse(mockView.deniedSpeechAuthorizeAlertShown)
    }
    
    // マイク使用許可が与えられてない場合、許可確認アラートが表示されることをテスト
    func testSpeechAuthorizationDenied() {
        // 不許可に設定
        presenter.authorized = false
        
        // expectationを作成
        let expectation = XCTestExpectation(description: "Alert shown")
        
        // viewDidLoad() を呼び出す
        presenter.viewDidLoad()
        
        // 数秒待機してからアラートが表示されたかどうかを確認する
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // アラートが表示されていることを確認
            XCTAssertTrue(self.mockView.deniedSpeechAuthorizeAlertShown)
            
            // expectationを完了させる
            expectation.fulfill()
        }
        
        // expectationが完了するまで待機
        wait(for: [expectation], timeout: 2.0)
    }
    
    // カウント数が最大まで達していない場合は、開始用の画面になる事を確認
    func testMaxCountNotReached() {
        
        presenter.matchCountManger.setCount(100)
        
        // viewDidLoad() を呼び出す
        presenter.viewDidLoad()
        
        // アプリ開始用のビューが呼ばれたことを確認
        XCTAssertTrue(mockView.startScreenShown)
    }
    
    // カウント数が最大まで達した場合は、終了用の画面になる事を確認
    func testMaxCountReached() {
        presenter.matchCountManger.setCount(1000000)
        
        // viewDidLoad() を呼び出す
        presenter.viewDidLoad()
        
        // アプリ終了用のビューが呼ばれたことを確認
        XCTAssertTrue(mockView.endScreenShown)
    }
    
}
