//
//  TodayRecordView.swift
//  ArigatouApp
//
//  Created by pero on 2024/07/07.
//

import UIKit

class TodayRecordViewController: UIViewController {
    
    private var todayCountLabel: UILabel!
    private var todayCountTitleLabel: UILabel!
    private var yesterDayCountLabel: UILabel!
    private var yesterDayCountTitleLabel: UILabel!
    private var dailyRecordButton: UIButton!
    private var weeklyRecordButton: UIButton!
    private var monthlyRecordButton: UIButton!
    
    private var presenter: TodayRecordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTodayCountTitleLabel()
        initTodayCountLabel()
        
        initYesterdayCountTitleLabel()
        initYesterdayCountLabel()
        
        initDailyRecordButton()
        initWeeklyRecordButton()
        initMonthlyRecordButton()
        
        presenter = TodayRecordPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    func initTodayCountTitleLabel() {
        todayCountTitleLabel = UILabel()
        todayCountTitleLabel.text = "今日のカウント"
        if UIDevice.current.userInterfaceIdiom == .pad {
            todayCountTitleLabel.font = .boldSystemFont(ofSize: 42)
        } else {
            todayCountTitleLabel.font = .boldSystemFont(ofSize: 22)
        }
        todayCountTitleLabel.backgroundColor = UIColor.clear
        todayCountTitleLabel.textColor = .white
        todayCountTitleLabel.textAlignment = .center
        todayCountTitleLabel.numberOfLines = 1

        todayCountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayCountTitleLabel)
        NSLayoutConstraint.activate([
            todayCountTitleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0),
            todayCountTitleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16.0),
            todayCountTitleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16.0)
        ])
    }
    
    func initTodayCountLabel() {
        todayCountLabel = UILabel()
 
        if UIDevice.current.userInterfaceIdiom == .pad {
            todayCountLabel.font = .boldSystemFont(ofSize: 62)
        } else {
            todayCountLabel.font = .boldSystemFont(ofSize: 40)
        }
        todayCountLabel.backgroundColor = UIColor.clear
        todayCountLabel.textColor = .white
        todayCountLabel.textAlignment = .center
        todayCountLabel.numberOfLines = 1

        todayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayCountLabel)
        NSLayoutConstraint.activate([
            todayCountLabel.topAnchor.constraint(
                equalTo: todayCountTitleLabel.bottomAnchor, constant: 20.0),
            todayCountLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16.0),
            todayCountLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16.0)
        ])
    }
    
    func initYesterdayCountTitleLabel(){
        yesterDayCountTitleLabel = UILabel()
        yesterDayCountTitleLabel.text = "昨日"
        if UIDevice.current.userInterfaceIdiom == .pad {
            yesterDayCountTitleLabel.font = .boldSystemFont(ofSize: 30)
        } else {
            yesterDayCountTitleLabel.font = .boldSystemFont(ofSize: 14)
        }
        yesterDayCountTitleLabel.backgroundColor = UIColor.clear
        yesterDayCountTitleLabel.textColor = .white
        yesterDayCountTitleLabel.textAlignment = .center
        yesterDayCountTitleLabel.numberOfLines = 1

        yesterDayCountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yesterDayCountTitleLabel)
        NSLayoutConstraint.activate([
            yesterDayCountTitleLabel.centerXAnchor.constraint(
                equalTo: todayCountLabel.centerXAnchor, constant: -140),
            yesterDayCountTitleLabel.centerYAnchor.constraint(
                equalTo: todayCountLabel.centerYAnchor, constant: -30),
            
        ])
    }

    func initYesterdayCountLabel(){
        yesterDayCountLabel = UILabel()
        yesterDayCountLabel.text = "900,000"
        if UIDevice.current.userInterfaceIdiom == .pad {
            yesterDayCountLabel.font = .boldSystemFont(ofSize: 40)
        } else {
            yesterDayCountLabel.font = .boldSystemFont(ofSize: 18)
        }
        yesterDayCountLabel.backgroundColor = UIColor.clear
        yesterDayCountLabel.textColor = .white
        yesterDayCountLabel.textAlignment = .center
        yesterDayCountLabel.numberOfLines = 1

        yesterDayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yesterDayCountLabel)
        NSLayoutConstraint.activate([
            yesterDayCountLabel.centerXAnchor.constraint(
                equalTo: yesterDayCountTitleLabel.centerXAnchor),
            yesterDayCountLabel.centerYAnchor.constraint(
                equalTo: yesterDayCountTitleLabel.centerYAnchor, constant: 30),
        ])
    }

    func initDailyRecordButton(){
        dailyRecordButton = UIButton()
        dailyRecordButton.setTitle("日別 集計", for:UIControl.State.normal)
        if UIDevice.current.userInterfaceIdiom == .pad {
            dailyRecordButton.titleLabel?.font =  UIFont.systemFont(ofSize: 26)
        } else {
            dailyRecordButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        }
        dailyRecordButton.backgroundColor = .systemBlue
        
        dailyRecordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dailyRecordButton)
        NSLayoutConstraint.activate([
            dailyRecordButton.centerYAnchor.constraint(
                equalTo: view.centerYAnchor),
            dailyRecordButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            dailyRecordButton.widthAnchor.constraint(equalToConstant: 280),
            dailyRecordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        dailyRecordButton.addTarget(self,
                              action: #selector(self.buttonDailyRecordTapped(sender:)),
                              for: .touchUpInside)
    }
    
    func initWeeklyRecordButton(){
        weeklyRecordButton = UIButton()
        weeklyRecordButton.setTitle("週別 集計", for:UIControl.State.normal)
        if UIDevice.current.userInterfaceIdiom == .pad {
            weeklyRecordButton.titleLabel?.font =  UIFont.systemFont(ofSize: 26)
        } else {
            weeklyRecordButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        }
        weeklyRecordButton.backgroundColor = .systemBlue
        
        weeklyRecordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weeklyRecordButton)
        NSLayoutConstraint.activate([
            weeklyRecordButton.centerYAnchor.constraint(
                equalTo: self.dailyRecordButton.centerYAnchor, constant: 60.0),
            weeklyRecordButton.centerXAnchor.constraint(
                equalTo: self.dailyRecordButton.centerXAnchor),
            weeklyRecordButton.widthAnchor.constraint(equalToConstant: 280),
            weeklyRecordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        weeklyRecordButton.addTarget(self,
                              action: #selector(self.buttonWeeklyRecordTapped(sender:)),
                              for: .touchUpInside)
    }
 
    func initMonthlyRecordButton(){
        monthlyRecordButton = UIButton()
        monthlyRecordButton.setTitle("月別 集計", for:UIControl.State.normal)
        if UIDevice.current.userInterfaceIdiom == .pad {
            monthlyRecordButton.titleLabel?.font =  UIFont.systemFont(ofSize: 26)
        } else {
            monthlyRecordButton.titleLabel?.font =  UIFont.systemFont(ofSize: 16)
        }
        monthlyRecordButton.backgroundColor = .systemBlue
        
        monthlyRecordButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(monthlyRecordButton)
        NSLayoutConstraint.activate([
            monthlyRecordButton.centerYAnchor.constraint(
                equalTo: self.weeklyRecordButton.centerYAnchor, constant: 60.0),
            monthlyRecordButton.centerXAnchor.constraint(
                equalTo: self.weeklyRecordButton.centerXAnchor),
            monthlyRecordButton.widthAnchor.constraint(equalToConstant: 280),
            monthlyRecordButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        monthlyRecordButton.addTarget(self,
                              action: #selector(self.buttonMonthlyRecordTapped(sender:)),
                              for: .touchUpInside)
    }
    
    @objc func buttonDailyRecordTapped(sender : Any) {
        self.navigationController?.pushViewController(DailyRecordViewController(), animated: true)
    }
    
    @objc func buttonWeeklyRecordTapped(sender : Any) {
        print("xxxx")
    }
    
    @objc func buttonMonthlyRecordTapped(sender : Any) {
        print("xxxx")
    }
}

extension TodayRecordViewController: TodayRecordPresenterOutput {
    func showTodayRecord(count: Int) {
        DispatchQueue.main.async {
            self.todayCountLabel.text =
                String.localizedStringWithFormat("%d", count)
        }
    }
    
    func showYesterdayRecord(count: Int) {
        DispatchQueue.main.async {
            self.yesterDayCountLabel.text =
                String.localizedStringWithFormat("%d", count)
        }
    }
}

