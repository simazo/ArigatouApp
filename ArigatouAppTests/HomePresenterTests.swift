//
//  ArigatouAppTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/04/16.
//

import XCTest
@testable import ArigatouApp

class MockPresenterOutput: HomePresenterOutput {
    func showDeleteAccountFailure(errorMessage: String) {
    }
    
    func showLoginMenu() {
    }
    
    func showPreLoginMenu() {
    }
    
    func showLogoutFailure(errorMessage: String) {
    }
    
    func showPlayVideoListMenu(menus: [String]) {
    }
    
    var videoShown = false
    func playVideo(url: String) {
        videoShown = true
    }
    
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

class MockHomePresenter: HomePresenter {
    var authorized: Bool = true // デフォルトは許可状態
    
    override func isAuthorized(completion: @escaping (Bool) -> Void) {
        completion(authorized)
    }
}

class HomePresenterTests: XCTestCase {
    
    var presenter: MockHomePresenter!
    var mockView: MockPresenterOutput!
    var testUserDefaults: UserDefaults!
    let factory = CounterFactory()
    
    override func setUp() {
        super.setUp()
        mockView = MockPresenterOutput()
        presenter = MockHomePresenter(view: mockView)
        testUserDefaults = UserDefaults(suiteName: "testSuite")
    }
    
    override func tearDown() {
        presenter = nil
        mockView = nil
        testUserDefaults.removePersistentDomain(forName: "testSuite")
        super.tearDown()
    }
    
    // マイク使用許可が与えられている場合、許可確認アラートが表示されないことをテスト
    func testSpeechAuthorization() {
        
        // 許可に設定
        presenter.authorized = true
        
        // handleAuthorizationStatus() を呼び出す
        presenter.handleAuthorizationStatus()
        
        // アラートが表示されないことを確認
        XCTAssertFalse(mockView.deniedSpeechAuthorizeAlertShown)
    }
    
    // マイク使用許可が与えられてない場合、許可確認アラートが表示されることをテスト
    func testSpeechAuthorizationDenied() {
        // 不許可に設定
        presenter.authorized = false
        
        // expectationを作成
        let expectation = XCTestExpectation(description: "Alert shown")
        
        // handleAuthorizationStatus() を呼び出す
        presenter.handleAuthorizationStatus()
        
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
        let totalCounter = factory.create(type: .total)
        totalCounter.setCount(100)
        
        // viewDidLoad() を呼び出す
        presenter.viewDidLoad()
        
        // アプリ開始用のビューが呼ばれたことを確認
        XCTAssertTrue(mockView.startScreenShown)
    }
    
    // カウント数が最大まで達した場合は、終了用の画面になる事を確認
    func testMaxCountReached() {
        let totalCounter = factory.create(type: .total)
        totalCounter.setCount(1000000)
        
        // viewDidLoad() を呼び出す
        presenter.viewDidLoad()
        
        // アプリ終了用のビューが呼ばれたことを確認
        XCTAssertTrue(mockView.endScreenShown)
    }
    
    // カウント数が一定数まで達した場合、動画再生することを確認
    func testPlayVideoReached() {
        
        let totalCounter = factory.create(type: .total)
        totalCounter.setCount(100)
        
        guard let videoURL = VideoList.shared.getUrlByCount(totalCounter.getCount()) else {
            return
        }
        // playVideo() を呼び出す
        mockView.playVideo(url: videoURL)
        
        // 動画再生用のビューが呼ばれたことを確認
        XCTAssertTrue(mockView.videoShown)
    }
    
    // カウント数が一定数まで達しない場合は、動画再生しないことを確認
    func testPlayVideoNotReached() {
        let totalCounter = factory.create(type: .total)
        totalCounter.setCount(99)
        
        guard let videoURL = VideoList.shared.getUrlByCount(totalCounter.getCount()) else {
            return
        }
        
        // playVideo() を呼び出す
        mockView.playVideo(url: videoURL)
        
        // 動画再生用のビューが呼ばれていないことを確認
        XCTAssertFalse(mockView.videoShown)
    }
}
