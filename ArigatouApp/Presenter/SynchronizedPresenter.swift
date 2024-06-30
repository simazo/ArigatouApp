//
//  SynchronizedPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/28.
//

import Firebase

protocol SynchronizedPresenterInput: AnyObject {
    func viewWillAppear()
    func synchronize()
}

protocol SynchronizedPresenterOutput: AnyObject {
    func redrawInformationLabel(localCount: Int, serverCount: Int, lastUpdateAt: Double)
    func showFindDataFailed(errorMessage: String)
    func showSynchronizedSuccess()
    func showSynchronizedFailed(errorMessage: String)
}

class SynchronizedPresenter {
    private weak var view: SynchronizedPresenterOutput?
    private var uid = ""
    
    private let dateManager = DateManager.shared
    private let factory = CounterFactory()
    private var totalCounter: Counter!
    private var dailyCounter: Counter!
    private var weeklyCounter: Counter!
    private var monthlyCounter: Counter!
    
    init(view: SynchronizedPresenterOutput) {
        self.view = view
        
        totalCounter = factory.create(type: .total)
        dailyCounter = factory.create(type: .daily)
        weeklyCounter = factory.create(type: .weekly)
        monthlyCounter = factory.create(type: .monthly)
    }
}
extension SynchronizedPresenter: SynchronizedPresenterInput {
    func viewWillAppear() {
        AuthManager.shared.isLoggedIn { (isAuthenticated, uid) in
            if isAuthenticated {
                let countManger = CountManager(RealtimeDBCountRepository())
                countManger.findByUid(uid: uid!) { result in
                    switch result {
                    case .success(let count):
                        self.uid = uid!
                        self.view?.redrawInformationLabel(
                            localCount: self.totalCounter.getCount(),
                            serverCount: count.totalCount,
                            lastUpdateAt: count.updateAt
                        )
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.view?.showFindDataFailed(errorMessage: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func synchronize() {
        let count = Count(
            uid: self.uid,
            totalCount: self.totalCounter.getCount(),
            dailyCount: self.dailyCounter.getAllCounts(),
            weeklyCount: self.weeklyCounter.getAllCounts(),
            monthlyCount: self.monthlyCounter.getAllCounts(),
            updateAt: Date().timeIntervalSince1970
        )
        let countManger = CountManager(RealtimeDBCountRepository())
        
        countManger.create(count){ success, error in
            if success {
                self.view?.showSynchronizedSuccess()
            } else {
                self.view?.showSynchronizedFailed(errorMessage: error!.localizedDescription)
            }
        }
    }
}
