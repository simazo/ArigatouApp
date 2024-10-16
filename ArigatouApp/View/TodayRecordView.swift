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
    private var cheeringMessageLabel: UILabel!
    
    private var buttonsStackView: UIStackView!
    
    private var presenter: TodayRecordPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTodayCountTitleLabel()
        initTodayCountLabel()
        initYesterdayCountTitleLabel()
        initYesterdayCountLabel()
        initAchievementRateLabel()
        initTargetCountButton()
        initCheeringMessageLabel()
        initDailyRecordButton()
        initWeeklyRecordButton()
        initMonthlyRecordButton()
        
        initButtonsStackView()
        
        initNavigation()
        
        presenter = TodayRecordPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    // 回転時にaxisを切り替える
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            if size.width > size.height {
                // 横向きの場合はボタンを横に並べる
                self.buttonsStackView.axis = .horizontal
            } else {
                // 縦向きの場合はボタンを縦に並べる
                self.buttonsStackView.axis = .vertical
            }
        })
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
        var fontSise = 18
        var positionX = -10
        var positionY = 40
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSise = fontSise * 2
            positionX = positionX * 2
            positionY = positionY * 2
        }
        
        achievementRateLabel = UILabel()
        achievementRateLabel.text = "30.5%"
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
    
    func initCheeringMessageLabel(){
        var fontSise = 24
        var positionX = -10
        var positionY = 40
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSise = fontSise * 2
            positionX = positionX * 2
            positionY = positionY * 2
        }
        
        cheeringMessageLabel = UILabel()
        cheeringMessageLabel.text = "その調子です、無理せずいきましょう♪"
        cheeringMessageLabel.font = .boldSystemFont(ofSize: CGFloat(fontSise))
        
        cheeringMessageLabel.backgroundColor = UIColor.clear
        cheeringMessageLabel.textColor = .white
        cheeringMessageLabel.textAlignment = .center
        cheeringMessageLabel.numberOfLines = 1

        cheeringMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cheeringMessageLabel)
        NSLayoutConstraint.activate([
            cheeringMessageLabel.centerXAnchor.constraint(
                equalTo: achievementRateLabel.centerXAnchor),
            cheeringMessageLabel.centerYAnchor.constraint(
                equalTo: achievementRateLabel.centerYAnchor, constant: CGFloat(positionY)),
            
        ])
    }
    
    func initTargetCountButton() {
        var fontSise = 10
        var width = 60
        var positionX = 90
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSise = fontSise * 2
            width = width * 2
            positionX = positionX * 2
        }
        
        targetCountButton = UIButton()
        targetCountButton.setTitle("目標数", for:UIControl.State.normal)
        targetCountButton.titleLabel?.font =  UIFont.systemFont(ofSize: CGFloat(fontSise))
        
        targetCountButton.backgroundColor = .systemBlue
        
        targetCountButton.translatesAutoresizingMaskIntoConstraints = false
        targetCountButton.widthAnchor.constraint(equalToConstant: CGFloat(width)).isActive = true
        
        view.addSubview(targetCountButton)
        NSLayoutConstraint.activate([
            targetCountButton.centerXAnchor.constraint(
                equalTo: achievementRateLabel.centerXAnchor, constant: CGFloat(positionX)),
            targetCountButton.centerYAnchor.constraint(
                equalTo: achievementRateLabel.centerYAnchor),
            
        ])
        
        targetCountButton.addTarget(self,
                              action: #selector(self.buttonTargetCountTapped(sender:)),
                              for: .touchUpInside)
    }
    
    func initYesterdayCountTitleLabel(){
        var fontSise = 14
        var positionX = -90
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
        var fontSize = 16
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = fontSize * 2
        }
        
        dailyRecordButton = UIButton()
        dailyRecordButton.setTitle("日別チャート", for: .normal)
        dailyRecordButton.titleLabel?.font = .boldSystemFont(ofSize: CGFloat(fontSize))
        dailyRecordButton.backgroundColor = .systemBlue
        
        dailyRecordButton.addTarget(self,
                                    action: #selector(self.buttonDailyRecordTapped(sender:)),
                                    for: .touchUpInside)
    }
    
    func initWeeklyRecordButton(){
        var fontSize = 16
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = fontSize * 2
        }
        
        weeklyRecordButton = UIButton()
        weeklyRecordButton.setTitle("週別チャート", for: .normal)
        weeklyRecordButton.titleLabel?.font = .boldSystemFont(ofSize: CGFloat(fontSize))
        weeklyRecordButton.backgroundColor = .systemBlue
        
        weeklyRecordButton.addTarget(self,
                                     action: #selector(self.buttonWeeklyRecordTapped(sender:)),
                                     for: .touchUpInside)
    }
    
    func initMonthlyRecordButton(){
        var fontSize = 16
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = fontSize * 2
        }
        
        monthlyRecordButton = UIButton()
        monthlyRecordButton.setTitle("月別チャート", for: .normal)
        monthlyRecordButton.titleLabel?.font = .boldSystemFont(ofSize: CGFloat(fontSize))
        monthlyRecordButton.backgroundColor = .systemBlue
        
        monthlyRecordButton.addTarget(self,
                                      action: #selector(self.buttonMonthlyRecordTapped(sender:)),
                                      for: .touchUpInside)
    }
    
    private func initButtonsStackView() {
        buttonsStackView = UIStackView(arrangedSubviews: [dailyRecordButton, weeklyRecordButton, monthlyRecordButton])
        buttonsStackView.axis = .vertical // 縦方向
        buttonsStackView.alignment = .center // ボタンを中央揃え
        buttonsStackView.distribution = .equalSpacing // ボタン間のスペースを均等に
        buttonsStackView.spacing = 20 // ボタン間のスペース
        
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsStackView)

        let spacing: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 180 : 100
        NSLayoutConstraint.activate([
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: achievementRateLabel.bottomAnchor, constant: spacing)
        ])

        // デバイスに応じてボタンの幅と高さを設定
        let buttonWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 240 * 2 : 240
        let buttonHeight: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 40 * 2 : 40
        for button in [dailyRecordButton, weeklyRecordButton, monthlyRecordButton] {
            button?.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button?.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        }
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
    
    @objc func buttonTargetCountTapped(sender : Any) {
        self.navigationController?.pushViewController(TargetCountView(), animated: true)
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
    
    func updateAchievementRateLabel(achievementRate: Double) {
        DispatchQueue.main.async {
            self.achievementRateLabel.text = String(format: "%.1f%%達成", achievementRate)
        }
    }
    
    func updateCheeringMessageLabel(message: String) {
        DispatchQueue.main.async {
            self.cheeringMessageLabel.text = message
        }
    }
    
}

