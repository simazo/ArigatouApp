//
//  ArigatouAppTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/04/16.
//

import XCTest
@testable import ArigatouApp

class MockPresenterOutput: PresenterOutput {

    // アラート表示されたか
    var deniedSpeechAuthorizeAlertShown = false
    
    func showDeniedSpeechAuthorizeAlert() {
        print("モックでアラート表示されました。")
        deniedSpeechAuthorizeAlertShown = true
    }
    
    func refreshCounterLabel(text: String) {}
    
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
    
    // マイク使用許可が与えられた場合にアラートが表示されないことをテスト
    func testSpeechAuthorization() {
        
        // 許可に設定
        presenter.authorized = true
        
        presenter.viewDidLoad()
        
        // アラートが表示されないことを確認
        XCTAssertFalse(mockView.deniedSpeechAuthorizeAlertShown)
    }
    
    // マイク使用許可が与えられなかった場合にアラートが表示されることをテスト
    func testSpeechAuthorizationDenied() {
        
        // 不許可に設定
        presenter.authorized = false
        
        presenter.viewDidLoad()
        
        // アラートが表示されることを確認
        XCTAssertTrue(mockView.deniedSpeechAuthorizeAlertShown)
        
    }

}
