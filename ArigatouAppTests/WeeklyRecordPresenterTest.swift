//
//  WeeklyRecordPresenterTest.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/09/26.
//

import XCTest
@testable import ArigatouApp

class WeeklyRecordPresenterTest: XCTestCase {
    
    class MockPresenterOutput: WeeklyRecordPresenterOutput {
        func updateLabel(avg: (count: Double, minWeek: String, maxWeek: String)) {}
        
        func updateChart(with chartData: [(weekNumber: String, count: Int)]) {}
        
        
        var isNextButtonEnabled: Bool?
        var isPrevButtonEnabled: Bool?
        func enableNextButton(_ isEnable: Bool) {
            isNextButtonEnabled = isEnable
        }
        func enablePrevButton(_ isEnable: Bool) {
            isPrevButtonEnabled = isEnable
        }
    }
    
    var presenter: WeeklyRecordPresenter!
    var mock: MockPresenterOutput!
    
    var testUserDefaults: UserDefaults!
    let factory = CounterFactory()
    private var weeklyCounter: Counter!
    
    var thisWeek: String = ""
    
    override func setUp() {
        super.setUp()
        mock = MockPresenterOutput()
        testUserDefaults = UserDefaults(suiteName: "testSuite")
        weeklyCounter = factory.create(type: .weekly, defaults: testUserDefaults)
        
        // アプリ開始日
        weeklyCounter.setCount(for: "2024-W27", count: 100)
        
        // アプリ起動（現在）
        thisWeek = "2024-W40"
        
        presenter = WeeklyRecordPresenter(view: mock, thisWeek: thisWeek, defaults: testUserDefaults)
    }
    
    override func tearDown() {
        presenter = nil
        mock = nil
        testUserDefaults.removePersistentDomain(forName: "testSuite")
        super.tearDown()
    }
    
    func testFillChartData(){
        var week = "2024-W27"
        presenter = WeeklyRecordPresenter(view: mock, thisWeek: week, defaults: testUserDefaults)
        presenter.fillChartData()
        XCTAssertEqual(presenter.chartData.count, 5) // 5の倍数
        XCTAssertEqual(presenter.chartData[0].weekNumber, week)
        XCTAssertEqual(presenter.chartData[presenter.chartData.count - 1].weekNumber, "")
        
        week = "2024-W28"
        presenter = WeeklyRecordPresenter(view: mock, thisWeek: week, defaults: testUserDefaults)
        presenter.fillChartData()
        XCTAssertEqual(presenter.chartData.count, 5) // 5の倍数
        XCTAssertEqual(presenter.chartData[1].weekNumber, week)
        XCTAssertEqual(presenter.chartData[presenter.chartData.count - 1].weekNumber, "")
        
        week = "2024-W36"
        presenter = WeeklyRecordPresenter(view: mock, thisWeek: week, defaults: testUserDefaults)
        presenter.fillChartData()
        XCTAssertEqual(presenter.chartData.count, 10) // 5の倍数
        XCTAssertEqual(presenter.chartData[0].weekNumber, "2024-W27")
        XCTAssertEqual(presenter.chartData[presenter.chartData.count - 1].weekNumber, "2024-W36")
        
    }
    
    func testFetchChartData() {
        let week = "2024-W40"
        presenter = WeeklyRecordPresenter(view: mock, thisWeek: week, defaults: testUserDefaults)
        presenter.fillChartData()
        
        // 最初のページ
        var result = presenter.fetchChartData()
        
        XCTAssertEqual(result[0].weekNumber, "2024-W37")
        XCTAssertEqual(result[result.count - 1].weekNumber, "")
        
        // 前のページへ
        presenter.prev()
        result = presenter.fetchChartData()

        XCTAssertEqual(result[0].weekNumber, "2024-W32")
        XCTAssertEqual(result[result.count - 1].weekNumber, "2024-W36")
        
        // ページを戻す
        presenter.next()
        result = presenter.fetchChartData()
        
        XCTAssertEqual(result[0].weekNumber, "2024-W37")
        XCTAssertEqual(result[result.count - 1].weekNumber, "")
        
    }
    
    func testUpdateButtonState() {
        let week = "2024-W40"
        presenter = WeeklyRecordPresenter(view: mock, thisWeek: week, defaults: testUserDefaults)
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
