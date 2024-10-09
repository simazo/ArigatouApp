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
    private var achievementRateLabel: UILabel!
    private var dailyRecordButton: UIButton!
    private var weeklyRecordButton: UIButton!
    private var monthlyRecordButton: UIButton!
    private var targetCountButton: UIButton!
    
    private var presenter: TodayRecordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTodayCountTitleLabel()
        initTodayCountLabel()
        
        initYesterdayCountTitleLabel()
        initYesterdayCountLabel()
        
        initAchievementRateLabel()
        
        initTargetCountButton()
        
        initDailyRecordButton()
        initWeeklyRecordButton()
        initMonthlyRecordButton()
        
        initNavigation()
        
        presenter = TodayRecordPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    private func initNavigation(){
        self.title = ""
        
        // 次の画面のBackボタンを「戻る」に変更
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:  "戻る", style:  .plain, target: nil, action: nil)
    }
    
    func initTodayCountTitleLabel() {
        todayCountTitleLabel = UILabel()
        todayCountTitleLabel.text = "今日"
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
                equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10.0),
            todayCountTitleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16.0),
            todayCountTitleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16.0)
        ])
    }
    
    func initTodayCountLabel() {
        todayCountLabel = UILabel()
 
        if UIDevice.current.userInterfaceIdiom == .pad {
            todayCountLabel.font = .boldSystemFont(ofSize: 68)
        } else {
            todayCountLabel.font = .boldSystemFont(ofSize: 44)
        }
        todayCountLabel.backgroundColor = UIColor.clear
        todayCountLabel.textColor = .white
        todayCountLabel.textAlignment = .center
        todayCountLabel.numberOfLines = 1

        todayCountLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(todayCountLabel)
        NSLayoutConstraint.activate([
            todayCountLabel.topAnchor.constraint(
                equalTo: todayCountTitleLabel.bottomAnchor, constant: 10.0),
            todayCountLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor, constant: 16.0),
            todayCountLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: -16.0)
        ])
    }
    
    func initAchievementRateLabel() {
        var fontSise = 14
        var positionX = -10
        var positionY = 40
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSise = fontSise * 2
            positionX = positionX * 2
            positionY = positionY * 2
        }
        
        achievementRateLabel = UILabel()
        achievementRateLabel.text = "30.5%達成"
        achievementRateLabel.font = .boldSystemFont(ofSize: CGFloat(fontSise))
        
        achievementRateLabel.backgroundColor = UIColor.clear
        achievementRateLabel.textColor = .white
        achievementRateLabel.textAlignment = .center
        achievementRateLabel.numberOfLines = 1

        achievementRateLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(achievementRateLabel)
        NSLayoutConstraint.activate([
            achievementRateLabel.centerXAnchor.constraint(
                equalTo: todayCountLabel.centerXAnchor),
            achievementRateLabel.centerYAnchor.constraint(
                equalTo: todayCountLabel.centerYAnchor, constant: CGFloat(positionY)),
            
        ])
    }
    
    func initTargetCountButton() {
        var fontSise = 10
        var width = 120
        var positionY = 30
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSise = fontSise * 2
            width = width * 2
            positionY = positionY * 2
        }
        
        targetCountButton = UIButton()
        targetCountButton.setTitle("目標数の変更", for:UIControl.State.normal)
        targetCountButton.titleLabel?.font =  UIFont.systemFont(ofSize: CGFloat(fontSise))
        
        targetCountButton.backgroundColor = .systemBlue
        
        targetCountButton.translatesAutoresizingMaskIntoConstraints = false
        targetCountButton.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        
        view.addSubview(targetCountButton)
        NSLayoutConstraint.activate([
            targetCountButton.centerXAnchor.constraint(
                equalTo: todayCountTitleLabel.centerXAnchor),
            targetCountButton.centerYAnchor.constraint(
                equalTo: achievementRateLabel.centerYAnchor, constant: CGFloat(positionY)),
            
        ])
        
        targetCountButton.addTarget(self,
                              action: #selector(self.buttonDailyRecordTapped(sender:)),
                              for: .touchUpInside)
    }
    
    func initYesterdayCountTitleLabel(){
        var fontSise = 14
        var positionX = -50
        var positionY = -30
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSise = fontSise * 2
            positionX = positionX * 2
            positionY = positionY * 2
        }
        
        yesterDayCountTitleLabel = UILabel()
        yesterDayCountTitleLabel.text = "昨日"
        yesterDayCountTitleLabel.font = .boldSystemFont(ofSize: CGFloat(fontSise))
        
        yesterDayCountTitleLabel.backgroundColor = UIColor.clear
        yesterDayCountTitleLabel.textColor = .white
        yesterDayCountTitleLabel.textAlignment = .center
        yesterDayCountTitleLabel.numberOfLines = 1

        yesterDayCountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(yesterDayCountTitleLabel)
        NSLayoutConstraint.activate([
            yesterDayCountTitleLabel.centerXAnchor.constraint(
                equalTo: todayCountLabel.centerXAnchor, constant: CGFloat(positionX)),
            yesterDayCountTitleLabel.centerYAnchor.constraint(
                equalTo: todayCountLabel.centerYAnchor, constant: CGFloat(positionY)),
            
        ])
    }

    func initYesterdayCountLabel(){
        var fontSise = 18
        var positionY = 20
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSise = fontSise * 2
            positionY = positionY * 2
        }
        
        yesterDayCountLabel = UILabel()
        yesterDayCountLabel.text = "900,000"
        yesterDayCountLabel.font = .boldSystemFont(ofSize: CGFloat(fontSise))
        
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
                equalTo: yesterDayCountTitleLabel.centerYAnchor, constant: CGFloat(positionY)),
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
        self.navigationController?.pushViewController(WeeklyRecordViewController(), animated: true)
    }
    
    @objc func buttonMonthlyRecordTapped(sender : Any) {
        self.navigationController?.pushViewController(MonthlyRecordViewController(), animated: true)
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

