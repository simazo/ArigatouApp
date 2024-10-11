//
//  CompletionYearManagerTests.swift
//  ArigatouAppTests
//
//  Created by pero on 2024/10/11.
//

import XCTest
@testable import ArigatouApp


class CompletionYearManagerTests: XCTestCase {
    
    func testTargetCountPerDay(){
        var year = 5.0
        var ret = CompletionYearManager.shared.targetCountPerDay(year)
        XCTAssertEqual(ret, 547.9)
        
        year = 0.5
        ret = CompletionYearManager.shared.targetCountPerDay(year)
        XCTAssertEqual(ret, 5479.5)
    }
    
    func testCalcDailyAchievementRate(){
        CompletionYearManager.shared.set(3) //　3年で達成
        let ret = CompletionYearManager.shared.calcDailyAchievementRate(dailyCount: 1000) // ある日の実績
        XCTAssertEqual(ret, 109.5)
    }
}
