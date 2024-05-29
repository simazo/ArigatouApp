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
    func redrawInformationLabel(matchCount: MatchCount)
    func showFindDataFailed(errorMessage: String)
    func showSynchronizedSuccess()
    func showSynchronizedFailed(errorMessage: String)
}

class SynchronizedPresenter {
    private weak var view: SynchronizedPresenterOutput?
    private var uid = ""
    
    init(view: SynchronizedPresenterOutput) {
        self.view = view
    }
}
extension SynchronizedPresenter: SynchronizedPresenterInput {
    func viewWillAppear() {
        AuthManager.shared.isLoggedIn { (isAuthenticated, uid) in
            if isAuthenticated {
                let matchCountManger = MatchCountManager(RealtimeDBMatchCountRepository())
                matchCountManger.findByUid(uid: uid!) { result in
                    switch result {
                    case .success(let matchCount):
                        self.uid = uid!
                        self.view?.redrawInformationLabel(matchCount: matchCount)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.view?.showFindDataFailed(errorMessage: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func synchronize() {
        let userMatchCount = MatchCount(
            uid: self.uid,
            count: UserDefaultsManager.getCount(),
            updateAt: Date().timeIntervalSince1970
        )
        let matchCountManger = MatchCountManager(RealtimeDBMatchCountRepository())
        
        matchCountManger.create(userMatchCount){ success, error in
            if success {
                self.view?.showSynchronizedSuccess()
            } else {
                self.view?.showSynchronizedFailed(errorMessage: error!.localizedDescription)
            }
        }
    }
}
