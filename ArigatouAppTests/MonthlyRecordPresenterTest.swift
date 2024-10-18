//
//  MonthlyRecordPresenterTest.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/10/02.
//

import XCTest
@testable import ArigatouApp

class MonthlyRecordPresenterTest: XCTestCase {
    
    class MockPresenterOutput: MonthlyRecordPresenterOutput {
        func updateLabel(avg: (sum: Int, count: Double, minYearMonth: String, maxYearMonth: String), calorie: (sumCalorie: Double, avgCalorie: Double)) {}
        
        func updateChart(with chartData: [(yearMonth: String, count: Int)]) {}
        
        var isNextButtonEnabled: Bool?
        var isPrevButtonEnabled: Bool?
        func enableNextButton(_ isEnable: Bool) {
            isNextButtonEnabled = isEnable
        }
        func enablePrevButton(_ isEnable: Bool) {
            isPrevButtonEnabled = isEnable
        }
    }
    
    var presenter: MonthlyRecordPresenter!
    var mock: MockPresenterOutput!
    
    var testUserDefaults: UserDefaults!
    let factory = CounterFactory()
    private var monthlyCounter: Counter!
    
    var thisYearMonth: String = ""
    
    override func setUp() {
        super.setUp()
        mock = MockPresenterOutput()
        testUserDefaults = UserDefaults(suiteName: "testSuite")
        monthlyCounter = factory.create(type: .monthly, defaults: testUserDefaults)
        
        // アプリ開始日
        monthlyCounter.setCount(for: "2024-01", count: 100)
        
        // アプリ起動（現在）
        thisYearMonth = "2024-12"
        
        presenter = MonthlyRecordPresenter(view: mock, thisYearMonth: thisYearMonth, defaults: testUserDefaults)
    }
    
    override func tearDown() {
        presenter = nil
        mock = nil
        testUserDefaults.removePersistentDomain(forName: "testSuite")
        super.tearDown()
    }
    
    func testFillChartData(){
        var yearMonth = "2024-04"
        presenter = MonthlyRecordPresenter(view: mock, thisYearMonth: yearMonth, defaults: testUserDefaults)
        presenter.fillChartData()
        XCTAssertEqual(presenter.chartData.count, 5) // 5の倍数
        XCTAssertEqual(presenter.chartData[0].yearMonth, yearMonth)
        XCTAssertEqual(presenter.chartData[presenter.chartData.count - 1].yearMonth, "")
        
        yearMonth = "2024-10"
        presenter = MonthlyRecordPresenter(view: mock, thisYearMonth: yearMonth, defaults: testUserDefaults)
        presenter.fillChartData()
        XCTAssertEqual(presenter.chartData.count, 10) // 5の倍数
        XCTAssertEqual(presenter.chartData[0].yearMonth, yearMonth)
        XCTAssertEqual(presenter.chartData[presenter.chartData.count - 1].yearMonth, "2024-01")
        
        yearMonth = "2025-01"
        presenter = MonthlyRecordPresenter(view: mock, thisYearMonth: yearMonth, defaults: testUserDefaults)
        presenter.fillChartData()
        XCTAssertEqual(presenter.chartData.count, 15) // 5の倍数
        XCTAssertEqual(presenter.chartData[0].yearMonth, yearMonth)
        XCTAssertEqual(presenter.chartData[presenter.chartData.count - 1].yearMonth, "")
        
    }
    
    func testFetchChartData() {
        let yearMonth = "2025-01"
        presenter = MonthlyRecordPresenter(view: mock, thisYearMonth: yearMonth, defaults: testUserDefaults)
        presenter.fillChartData()
        
        // 0ページ目
        var result = presenter.fetchChartData()
        
        XCTAssertEqual(result[0].yearMonth, "2025-01")
        XCTAssertEqual(result[result.count - 1].yearMonth, "2024-09")
        
        // 1ページ目
        presenter.prev()
        result = presenter.fetchChartData()

        XCTAssertEqual(result[0].yearMonth, "2024-08")
        XCTAssertEqual(result[result.count - 1].yearMonth, "2024-04")
        
        // ページを戻す
        presenter.next()
        result = presenter.fetchChartData()
        
        XCTAssertEqual(result[0].yearMonth, "2025-01")
        XCTAssertEqual(result[result.count - 1].yearMonth, "2024-09")
        
    }
    
    func testUpdateButtonState() {
        let yearMonth = "2025-01"
        presenter = MonthlyRecordPresenter(view: mock, thisYearMonth: yearMonth, defaults: testUserDefaults)
        presenter.fillChartData()
        
        _ = presenter.fetchChartData()
        presenter.updateButtonState()
        
        // ボタンの状態が正しく設定されているか確認
        XCTAssertEqual(mock.isNextButtonEnabled, false)
        XCTAssertEqual(mock.isPrevButtonEnabled, true)
        
        // 1ページ目
        presenter.prev()
        _ = presenter.fetchChartData()
        presenter.updateButtonState()
        
        // ボタンの状態が正しく設定されているか確認
        XCTAssertEqual(mock.isNextButtonEnabled, true)
        XCTAssertEqual(mock.isPrevButtonEnabled, true)
        
        // 最後のページ
        presenter.prev()
        _ = presenter.fetchChartData()
        presenter.updateButtonState()
        
        // ボタンの状態が正しく設定されているか確認
        XCTAssertEqual(mock.isNextButtonEnabled, true)
        XCTAssertEqual(mock.isPrevButtonEnabled, false)

        // 1ページ戻す
        presenter.next()
        _ = presenter.fetchChartData()
        presenter.updateButtonState()
        
        // ボタンの状態が正しく設定されているか確認
        XCTAssertEqual(mock.isNextButtonEnabled, true)
        XCTAssertEqual(mock.isPrevButtonEnabled, true)

    }
    

}

