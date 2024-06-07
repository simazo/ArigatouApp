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
    private var synchronizedButton: UIButton!
    private var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initInformationLabel()
        initSynchronizedButton()
        initDescriptionLabel()
        
        presenter = SynchronizedPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func initInformationLabel(){
        informationLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            informationLabel.font = .boldSystemFont(ofSize: 26)
        } else {
            informationLabel.font = .boldSystemFont(ofSize: 16)
        }
        informationLabel.backgroundColor = UIColor.clear
        informationLabel.textColor = .white
        informationLabel.textAlignment = .center
        informationLabel.numberOfLines = 0
        
        // 中央に配置
        informationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(informationLabel)
        NSLayoutConstraint.activate([
            informationLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -80.0),
            informationLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func initSynchronizedButton(){
        synchronizedButton = UIButton()
        synchronizedButton.setTitle("同期", for:UIControl.State.normal)
        if UIDevice.current.userInterfaceIdiom == .pad {
            synchronizedButton.titleLabel?.font =  UIFont.systemFont(ofSize: 26)
        } else {
            synchronizedButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        }
        synchronizedButton.backgroundColor = .systemBlue
        
        synchronizedButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(synchronizedButton)
        NSLayoutConstraint.activate([
            synchronizedButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            synchronizedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            synchronizedButton.widthAnchor.constraint(equalToConstant: 280),
            synchronizedButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        synchronizedButton.addTarget(self,
                              action: #selector(SynchronizedViewController.buttonSynchronizedTapped(sender:)),
                              for: .touchUpInside)
    }
 
    @objc func buttonSynchronizedTapped(sender : Any) {
        presenter.synchronize()
    }
    
    func initDescriptionLabel() {
        descriptionLabel = UILabel()
        if UIDevice.current.userInterfaceIdiom == .pad {
            descriptionLabel.font = .boldSystemFont(ofSize: 26)
        } else {
            descriptionLabel.font = .boldSystemFont(ofSize: 16)
        }
        descriptionLabel.backgroundColor = UIColor.clear
        descriptionLabel.textColor = .white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.centerYAnchor.constraint(equalTo: synchronizedButton.centerYAnchor, constant: 60),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        descriptionLabel.text = "※同期すると端末もしくはサーバ、\n多い方のカウントで更新されます"
    }
}
extension SynchronizedViewController: SynchronizedPresenterOutput {
    func showSynchronizedFailed(errorMessage: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "同期エラー", message: errorMessage + ":時間を置いてやり直してくさい。解決しない場合はお問い合わせ下さい。")
        }
    }
    
    func showSynchronizedSuccess() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
            self.showAlert(title: "同期成功", message: "カウント数は同期されました。")
        }
    }
    
    func redrawInformationLabel(matchCount: MatchCount) {
        DispatchQueue.main.async {
            self.informationLabel.text = """
            端末のカウント：\(UserDefaultsManager.shared.getCount())
            サーバのカウント：\(matchCount.count)
            前回更新：\(self.dateFormat(matchCount.updateAt))
            """
        }
    }
    
    func showFindDataFailed(errorMessage: String) {
        DispatchQueue.main.async {
            self.showAlert(title: "データ取得エラー", message: errorMessage + ":時間を置いてアクセスし直してくさい。解決しない場合はお問い合わせ下さい。")
        }
    }
    
    private func dateFormat(_ date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
