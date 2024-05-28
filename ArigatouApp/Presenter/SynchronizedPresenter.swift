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
}

class SynchronizedPresenter {
    private weak var view: SynchronizedPresenterOutput?
    var matchCountManger: MatchCountManager!
    var matchCount: Int
    
    init(view: SynchronizedPresenterOutput) {
        self.view = view
        
        // UserDefaultsから現在の（ローカルの）マッチ数を取得
        matchCountManger = MatchCountManager(UserDefaultsMatchCountRepository())
        matchCount = matchCountManger.getCount()
        matchCountManger = nil
    }
    

}
extension SynchronizedPresenter: SynchronizedPresenterInput {
    func viewWillAppear() {
        AuthManager.shared.isLoggedIn { (isAuthenticated, uid) in
            if isAuthenticated {
                self.matchCountManger = MatchCountManager(RealtimeDBMatchCountRepository(uid: uid!))
                let lastUpdatedCount = self.matchCountManger.getCount ()
                
                //view?.showLoginMenu()
            }
        }
    }
}
