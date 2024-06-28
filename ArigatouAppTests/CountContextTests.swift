//
//  CountContextTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/06/27.
//

import XCTest
@testable import ArigatouApp

final class CountContextTests: XCTestCase {

    var userDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        userDefaults = UserDefaults(suiteName: "testSuite")
    }
    
    override func tearDown() {
        userDefaults.removePersistentDomain(forName: "testSuite")
        super.tearDown()
    }

    func testTotalCountStrategy() {
        let strategy = TotalCountStrategy(defaults: userDefaults)
        let context = CountContext(strategy: strategy)
        
        context.setCount(for: UserDefaultsKeys.TOTAL_COUNT, count: 10)
        XCTAssertEqual(context.getCount(for: UserDefaultsKeys.TOTAL_COUNT), 10)

        context.incrementCount(for: UserDefaultsKeys.TOTAL_COUNT)
        XCTAssertEqual(context.getCount(for: UserDefaultsKeys.TOTAL_COUNT), 11)
    }
    
    func testDailyCountStrategy() {
        let strategy = DailyCountStrategy(defaults: userDefaults)
        let context = CountContext(strategy: strategy)
        
        context.setCount(for: "2023-10-01", count: 100)
        XCTAssertEqual(context.getCount(for: "2023-10-01"), 100)
        
        context.setCount(for: "2023-10-02", count: 200)
        XCTAssertEqual(context.getCount(for: "2023-10-02"), 200)

        context.incrementCount(for: "2023-10-01")
        XCTAssertEqual(context.getCount(for: "2023-10-01"), 101)
        
        context.incrementCount(for: "2023-10-02")
        XCTAssertEqual(context.getCount(for: "2023-10-02"), 201)
    }
    
    func testWeeklyCountStrategy() {
        let strategy = WeeklyCountStrategy(defaults: userDefaults)
        let context = CountContext(strategy: strategy)
        
        context.setCount(for: "2023-W30", count: 100)
        XCTAssertEqual(context.getCount(for: "2023-W30"), 100)
        
        context.setCount(for: "2023-W31", count: 200)
        XCTAssertEqual(context.getCount(for: "2023-W31"), 200)
        
        context.incrementCount(for: "2023-W30")
        XCTAssertEqual(context.getCount(for: "2023-W30"), 101)
        
        context.incrementCount(for: "2023-W31")
        XCTAssertEqual(context.getCount(for: "2023-W31"), 201)
    }
    
    func testMonthlyCountStrategy() {
        let strategy = MonthlyCountStrategy(defaults: userDefaults)
        let context = CountContext(strategy: strategy)
        
        context.setCount(for: "2023-01", count: 1000)
        XCTAssertEqual(context.getCount(for: "2023-01"), 1000)
        
        context.setCount(for: "2023-12", count: 2000)
        XCTAssertEqual(context.getCount(for: "2023-12"), 2000)
        
        context.incrementCount(for: "2023-01")
        XCTAssertEqual(context.getCount(for: "2023-01"), 1001)
        
        context.incrementCount(for: "2023-12")
        XCTAssertEqual(context.getCount(for: "2023-12"), 2001)
    }
}
