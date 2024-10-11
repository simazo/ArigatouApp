//
//  TargetCountView.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/09.
//

import UIKit

class TargetCountView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private var description1Label: UILabel!
    private var description2Label: UILabel!
    private var achievementRateLabel: UILabel!
    private var pickerView: UIPickerView!
    private var presenter: TargetCountPresenter!
    
    let items: [(title: String, value: Double)] = [
        ("5年で100万回達成する", 5),
        ("4年で100万回達成する", 4),
        ("3年で100万回達成する", 3),
        ("2年で100万回達成する", 2),
        ("1年で100万回達成する", 1),
        ("半年で100万回達成する", 0.5),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initPickerView()
        initDescription1Label()
        initAchievementRateLabel()
        initDescription2Label()
        
        pickerView.reloadAllComponents()
        
        presenter = TargetCountPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let year = presenter.completionYear()
        
        if let initialIndex = items.firstIndex(where: { $0.value == year }) {
            pickerView.selectRow(initialIndex, inComponent: 0, animated: false)
            pickerView(pickerView, didSelectRow: initialIndex, inComponent: 0)
        }
    }
    
    func initPickerView() {
        pickerView = UIPickerView() // プログラムからUIPickerViewをインスタンス化
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
        
        pickerView.frame = CGRect(x: 16, y: 200, width: view.frame.width - 32, height: 200)
        pickerView.backgroundColor = .gray // デバッグ用に背景色を設定

        // レイアウトの設定 (例としてtodayCountTitleLabelの下に配置)
        NSLayoutConstraint.activate([
            pickerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            pickerView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // UIPickerViewのdelegateとdataSourceの設定
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func initDescription1Label(){
        description1Label = UILabel()
        description1Label.text = "1日あたりの目標数は"
        if UIDevice.current.userInterfaceIdiom == .pad {
            description1Label.font = .boldSystemFont(ofSize: 24)
        } else {
            description1Label.font = .boldSystemFont(ofSize: 18)
        }
        description1Label.backgroundColor = UIColor.clear
        description1Label.textColor = .white
        description1Label.textAlignment = .center
        description1Label.numberOfLines = 0

        description1Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(description1Label)
        NSLayoutConstraint.activate([
            description1Label.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 40),
            description1Label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16.0),
            description1Label.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16.0)
        ])
    }
    
    func initAchievementRateLabel(){
        achievementRateLabel = UILabel()
        achievementRateLabel.text = "4,260回"
        if UIDevice.current.userInterfaceIdiom == .pad {
            achievementRateLabel.font = .boldSystemFont(ofSize: 48)
        } else {
            achievementRateLabel.font = .boldSystemFont(ofSize: 24)
        }
        achievementRateLabel.backgroundColor = UIColor.clear
        achievementRateLabel.textColor = .white
        achievementRateLabel.textAlignment = .center
        achievementRateLabel.numberOfLines = 0

        achievementRateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(achievementRateLabel)
        NSLayoutConstraint.activate([
            achievementRateLabel.topAnchor.constraint(equalTo: description1Label.bottomAnchor, constant: 10),
            achievementRateLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16.0),
            achievementRateLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16.0)
        ])
    }
    
    func initDescription2Label(){
        description2Label = UILabel()
        description2Label.text = "です"
        if UIDevice.current.userInterfaceIdiom == .pad {
            description2Label.font = .boldSystemFont(ofSize: 24)
        } else {
            description2Label.font = .boldSystemFont(ofSize: 18)
        }
        description2Label.backgroundColor = UIColor.clear
        description2Label.textColor = .white
        description2Label.textAlignment = .center
        description2Label.numberOfLines = 0

        description2Label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(description2Label)
        NSLayoutConstraint.activate([
            description2Label.topAnchor.constraint(equalTo: achievementRateLabel.bottomAnchor, constant: 10),
            description2Label.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16.0),
            description2Label.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16.0)
        ])
    }
    
    // UIPickerViewの列数を設定
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数を設定
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    // 表示するテキストを設定
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row].title
    }
    
    // 項目選択時の処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedItem = items[row]
        presenter.calcAchievementRate(year: selectedItem.value)
        presenter.setYear(year: selectedItem.value)
    }
}

extension TargetCountView: TargetCountPresenterOutput {
    func updateAchievementRateLabel(text: String) {
        DispatchQueue.main.async {
            self.achievementRateLabel.text = text
        }
    }
}
