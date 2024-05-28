//
//  SynchronizedPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/28.
//

protocol SynchronizedPresenterInput: AnyObject {
    func viewWillAppear()
}

protocol SynchronizedPresenterOutput: AnyObject {
    func redrawInformationLabel(matchCount: MatchCount)
    func showFindDataFailed(errorMessage: String)
}

class SynchronizedPresenter {
    private weak var view: SynchronizedPresenterOutput?
    
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
                        self.view?.redrawInformationLabel(matchCount: matchCount)
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.view?.showFindDataFailed(errorMessage: error.localizedDescription)
                    }
                }
            }
        }
    }
}
