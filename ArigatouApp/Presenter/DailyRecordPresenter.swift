//
//  DailyRecordPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/07/15.
//

import Foundation

protocol DailyRecordPresenterInput: AnyObject {
    func viewWillAppear()
}

protocol DailyRecordPresenterOutput: AnyObject {
    func showChart(with dailyCounts: [String: Int])
}

class DailyRecordPresenter {
    private weak var view: DailyRecordPresenterOutput?
    
    init(view: DailyRecordPresenterOutput) {
        self.view = view  
    }
}

extension DailyRecordPresenter: DailyRecordPresenterInput {
    func viewWillAppear() {
        if let dailyCounts = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.DAILY_COUNT) as? [String: Int] {
            self.view?.showChart(with: dailyCounts)
        }
    }
}
