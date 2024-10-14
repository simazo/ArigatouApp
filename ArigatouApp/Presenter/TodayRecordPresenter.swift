//
//  TodayRecordPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/07/07.
//

import Foundation

protocol TodayRecordPresenterInput: AnyObject {
    func viewWillAppear()
}

protocol TodayRecordPresenterOutput: AnyObject {
    func showTodayRecord(count: Int)
    func showYesterdayRecord(count: Int)
    func updateAchievementRateLabel(achievementRate: Double)
    func updateCheeringMessageLabel(message: String)
}

class TodayRecordPresenter {
    private weak var view: TodayRecordPresenterOutput?
    
    private let dateManager = DateManager.shared
    private let factory = CounterFactory()
    
    private var dailyCounter: Counter!
    
    init(view: TodayRecordPresenterOutput) {
        self.view = view
        dailyCounter = factory.create(type: .daily)
    }
}
extension TodayRecordPresenter: TodayRecordPresenterInput {
    func viewWillAppear() {
        let yesterday = Calendar.current.date(byAdding: .day,value: -1, to: Date())!
        
        let todayCount = dailyCounter.getCount(
            for: dateManager.formattedDateString()
        )
        let yesterDayCount = dailyCounter.getCount(
            for: dateManager.formattedDateString(date: yesterday)
        )
        self.view?.showTodayRecord(count: todayCount)
        self.view?.showYesterdayRecord(count: yesterDayCount)
        
        let rate = CompletionYearManager.shared.calcDailyAchievementRate(dailyCount: todayCount)
        let message = CheeringMessage.shared.getMessage(achievementRate: rate)
        
        view?.updateAchievementRateLabel(achievementRate: rate)
        view?.updateCheeringMessageLabel(message: message)
    }
    
}
