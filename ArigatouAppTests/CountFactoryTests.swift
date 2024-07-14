//
//  CountFactoryTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/06/27.
//

import XCTest
@testable import ArigatouApp

final class CountFactoryTests: XCTestCase {

    var testUserDefaults: UserDefaults!
    let factory = CounterFactory()
    
    override func setUp() {
        super.setUp()
        testUserDefaults = UserDefaults(suiteName: "testSuite")
    }
    
    override func tearDown() {
        testUserDefaults.removePersistentDomain(forName: "testSuite")
        super.tearDown()
    }

    func testTotalCounter() {
        let totalCounter = factory.create(type: .total)

        totalCounter.setCount(10)
        XCTAssertEqual(totalCounter.getCount(), 10)

        totalCounter.incrementCount()
        XCTAssertEqual(totalCounter.getCount(), 11)
    }
    
    func testDailyCounter() {
        let dailyCounter = factory.create(type: .daily)
        
        dailyCounter.setCount(for: "2023-10-01", count: 100)
        XCTAssertEqual(dailyCounter.getCount(for: "2023-10-01"), 100)
        
        dailyCounter.setCount(for: "2023-10-02", count: 200)
        XCTAssertEqual(dailyCounter.getCount(for: "2023-10-02"), 200)

        dailyCounter.incrementCount(for: "2023-10-01")
        XCTAssertEqual(dailyCounter.getCount(for: "2023-10-01"), 101)
        
        dailyCounter.incrementCount(for: "2023-10-02")
        XCTAssertEqual(dailyCounter.getCount(for: "2023-10-02"), 201)
    }
    
    func testWeeklyCounter() {
        let weeklyCounter = factory.create(type: .weekly)
        
        weeklyCounter.setCount(for: "2023-W30", count: 100)
        XCTAssertEqual(weeklyCounter.getCount(for: "2023-W30"), 100)
        
        weeklyCounter.setCount(for: "2023-W31", count: 200)
        XCTAssertEqual(weeklyCounter.getCount(for: "2023-W31"), 200)
        
        weeklyCounter.incrementCount(for: "2023-W30")
        XCTAssertEqual(weeklyCounter.getCount(for: "2023-W30"), 101)
        
        weeklyCounter.incrementCount(for: "2023-W31")
        XCTAssertEqual(weeklyCounter.getCount(for: "2023-W31"), 201)
    }
    
    func testMonthlyCounter() {
        let monthlyCounter = factory.create(type: .monthly)
        
        monthlyCounter.setCount(for: "2023-01", count: 1000)
        XCTAssertEqual(monthlyCounter.getCount(for: "2023-01"), 1000)
        
        monthlyCounter.setCount(for: "2023-12", count: 2000)
        XCTAssertEqual(monthlyCounter.getCount(for: "2023-12"), 2000)
        
        monthlyCounter.incrementCount(for: "2023-01")
        XCTAssertEqual(monthlyCounter.getCount(for: "2023-01"), 1001)
        
        monthlyCounter.incrementCount(for: "2023-12")
        XCTAssertEqual(monthlyCounter.getCount(for: "2023-12"), 2001)
    }
}
