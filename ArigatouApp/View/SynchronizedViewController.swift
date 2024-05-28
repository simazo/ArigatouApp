//
//  SynchronizedViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/28.
//

import UIKit

class SynchronizedViewController: UIViewController {
    private var presenter: SynchronizedPresenter!
    private var informationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initInformationLabel()
        
        presenter = SynchronizedPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func initInformationLabel(){
        informationLabel = UILabel()
        informationLabel.font = .boldSystemFont(ofSize: 16)
        informationLabel.backgroundColor = UIColor.clear
        informationLabel.textColor = .white
        informationLabel.textAlignment = .center
        informationLabel.numberOfLines = 0
        
        // 中央に配置
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(informationLabel)
        NSLayoutConstraint.activate([
            informationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
extension SynchronizedViewController: SynchronizedPresenterOutput {
    func redrawInformationLabel(matchCount: MatchCount) {
        informationLabel.text = """
            現在のカウント：\(matchCount.count)
            前回更新日：\(dateFormat(matchCount.updateAt))
            """
    }
    
    func showFindDataFailed(errorMessage: String) {
        self.showAlert(title: "データ取得エラー", message: errorMessage + ":時間を置いてアクセスし直してくさい。解決しない場合はお問い合わせ下さい。")
    }
    
    private func dateFormat(_ date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
