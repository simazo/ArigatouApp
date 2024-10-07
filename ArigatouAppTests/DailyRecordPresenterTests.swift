//
//  DailyRecordPresenterTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/09/11.
//

import XCTest
@testable import ArigatouApp

class DailyRecordPresenterTests: XCTestCase {
    
    class MockPresenterOutput: DailyRecordPresenterOutput {
        func updateLabel(avg: (count: Double, minDate: String, maxDate: String)) {
        }

        
        func updateChart(with chartData: [(day: String, date: String, count: Int)]) {}
        
        var isNextButtonEnabled: Bool?
        var isPrevButtonEnabled: Bool?
        func enableNextButton(_ isEnable: Bool) {
            isNextButtonEnabled = isEnable
        }
        func enablePrevButton(_ isEnable: Bool) {
            isPrevButtonEnabled = isEnable
        }
    }
    
    var presenter: DailyRecordPresenter!
    var mock: MockPresenterOutput!
    
    var testUserDefaults: UserDefaults!
    let factory = CounterFactory()
    private var dailyCounter: Counter!
    
    var todayDate: Date!
    
    override func setUp() {
        super.setUp()
        mock = MockPresenterOutput()
        testUserDefaults = UserDefaults(suiteName: "testSuite")
        dailyCounter = factory.create(type: .daily, defaults: testUserDefaults)
        
        // アプリ開始日を2024年8月27日（火曜日）とする
        dailyCounter.setCount(for: "2024-08-22", count: 100)
        
        // アプリ起動（現在日）を2024年9月５日（木曜）とする
        todayDate = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 5))
        
        presenter = DailyRecordPresenter(view: mock, today: todayDate, defaults: testUserDefaults)
    }
    
    override func tearDown() {
        presenter = nil
        mock = nil
        testUserDefaults.removePersistentDomain(forName: "testSuite")
        super.tearDown()
    }
    
    func testFillDate() {
 
        presenter.fillChartData(from: todayDate)
        
        // chartData の日付が正しく設定されているか確認
        XCTAssertEqual(presenter.chartData[0].date, "2024-09-01") // 日曜日
        XCTAssertEqual(presenter.chartData[1].date, "2024-09-02") // 月曜日
        XCTAssertEqual(presenter.chartData[2].date, "2024-09-03") // 火曜日
        XCTAssertEqual(presenter.chartData[3].date, "2024-09-04") // 水曜日
        XCTAssertEqual(presenter.chartData[4].date, "2024-09-05") // 木曜日
        XCTAssertEqual(presenter.chartData[5].date, "") // 金曜日
        XCTAssertEqual(presenter.chartData[6].date, "") // 土曜日
    }
    
    func testPrev() {

        // prev() を呼び出す
        let resultDate = presenter.prev()
        
        // １週間前に移動する事を確認
        let expectedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 29))!
        XCTAssertEqual(resultDate, expectedDate)
    }
    
    func testNext() {
        
        // next() を呼び出す
        let resultDate = presenter.next()
        
        // １週間後に移動することを確認
        let expectedDate = Calendar.current.date(from: DateComponents(year: 2024, month: 9, day: 12))!
        XCTAssertEqual(resultDate, expectedDate)
    }
    
    func testUpdateButtonState() {
        
        presenter.fillChartData(from: todayDate)
        presenter.updateButtonState()
        
        // ボタンの状態が正しく設定されているか確認
        XCTAssertEqual(mock.isNextButtonEnabled, false) // next は無効
        XCTAssertEqual(mock.isPrevButtonEnabled, true)  // prev は有効
        
        // 前の週へ移動
        presenter.fillChartData(from: presenter.prev())
        presenter.updateButtonState()
        
        // ボタンの状態が正しく設定されているか確認
        XCTAssertEqual(mock.isNextButtonEnabled, true)
        XCTAssertEqual(mock.isPrevButtonEnabled, true)
        
        // 前の週へ移動
        presenter.fillChartData(from: presenter.prev())
        presenter.updateButtonState()
        
        // ボタンの状態が正しく設定されているか確認
        XCTAssertEqual(mock.isNextButtonEnabled, true)
        XCTAssertEqual(mock.isPrevButtonEnabled, false) // 開始日まで達したので無効
    }
    
    func testAverageCount() {
        // 1件のみでテスト
        todayDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 22))
        
        // 8/18〜8/24の週
        presenter = DailyRecordPresenter(view: mock, today: todayDate, defaults: testUserDefaults)
        presenter.fillChartData(from: todayDate)
        
        var result = presenter.averageCount()
        XCTAssertEqual(result.count, 100)
        XCTAssertEqual(result.minDate, "2024年08月22日")
        XCTAssertEqual(result.maxDate, "2024年08月22日")
        
        //複数件でテスト
        // setUpで2024-08-22, count:100
        dailyCounter.setCount(for: "2024-08-23", count: 200)
        dailyCounter.setCount(for: "2024-08-24", count: 300)

        // アプリ起動
        todayDate = Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 24))
        
        // 8/18〜8/24の週
        presenter = DailyRecordPresenter(view: mock, today: todayDate, defaults: testUserDefaults)
        presenter.fillChartData(from: todayDate)
        
        result = presenter.averageCount()
        XCTAssertEqual(result.count, 200)
        XCTAssertEqual(result.minDate, "2024年08月22日")
        XCTAssertEqual(result.maxDate, "2024年08月24日")
    }
}

