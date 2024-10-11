//
//  TargetCountPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/10.
//

import Foundation

protocol TargetCountPresenterInput: AnyObject {
    func completionYear() -> Double
    func calcAchievementRate(year: Double)
    func setYear(year: Double)
}

protocol TargetCountPresenterOutput: AnyObject {
    func updateAchievementRateLabel(text: String)
}

class TargetCountPresenter {
    private weak var view: TargetCountPresenterOutput?
    
    init(view: TargetCountPresenterOutput) {
        self.view = view
    }
}

extension TargetCountPresenter: TargetCountPresenterInput {

    func completionYear() -> Double {
        return CompletionYearManager.shared.get()
    }
    
    func calcAchievementRate(year: Double) {
        
        let countPerDay = CompletionYearManager.shared.targetCountPerDay(year)
        
        // フォーマットしてviewへ渡す
        view?.updateAchievementRateLabel(text: String(format: "%.1f回", countPerDay))
    }

    func setYear(year: Double) {
        CompletionYearManager.shared.set(year)
    }
    
    
}
