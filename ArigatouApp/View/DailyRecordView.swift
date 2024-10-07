//
//  DailyRecordView.swift
//  ArigatouApp
//
//  Created by pero on 2024/07/15.
//

import UIKit
import DGCharts

class DailyRecordViewController: UIViewController, ChartViewDelegate {
    
    private var chartView: BarChartView!
    private var presenter: DailyRecordPresenter!
    
    var infoLabel: UILabel!
    var prevButton: UIButton!
    var nextButton: UIButton!
    
    private var customXAxisLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DailyRecordPresenter(view: self, today: Date()) //初期値は現在日
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initChartView()
        initButtons()
        initInfoLabel()
        presenter.fillChartData(from: Date()) //初期値は現在日
        presenter.updateButtonState()
        updateChart(with: presenter.chartData)
        updateLabel(avg:presenter.averageCount())
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        // 向きが変わる前に何か処理をしたい場合はここに記述

        coordinator.animate(alongsideTransition: { _ in
            // デバイスの向きが変わったときにカスタムラベルを再初期化
            self.initCustomXAxisLabels(with: self.presenter.chartData)
        }, completion: nil)
    }

    func initChartView() {
        chartView = BarChartView()
        chartView.delegate = self
        chartView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(chartView)
        
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
        
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.axisMinimum = 0
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelRotationAngle = -45
        
        chartView.xAxis.labelTextColor = .white
        chartView.leftAxis.labelTextColor = .white
        
        chartView.doubleTapToZoomEnabled = false // ダブルタップでのズームを無効化
        chartView.pinchZoomEnabled = false // ピンチズームを無効化
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        guard let barEntry = entry as? BarChartDataEntry else { return }
        let index = Int(barEntry.x) // 選択されたエントリのインデックスを取得
        guard index < presenter.chartData.count else { return }
        
        let data = presenter.chartData[index] // 選択されたデータを取得
        let count = data.count // カウント
        let date = data.date // 日付
        
        // カスタムポップアップの表示
        if !date.isEmpty { showCustomPopup(withCount: count, date: date) }
    }
    
    func showCustomPopup(withCount count: Int, date: String) {
        let popupLabel = UILabel()
        popupLabel.text = "\(date)\n\(count)回"
        popupLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        popupLabel.textColor = .white
        popupLabel.textAlignment = .center
        popupLabel.layer.cornerRadius = 8
        popupLabel.layer.masksToBounds = true
        popupLabel.numberOfLines = 0
        
        // ラベルのサイズと位置を設定
        popupLabel.frame.size = CGSize(width: 150, height: 60)
        popupLabel.center = view.center // 中央に配置
        popupLabel.alpha = 0 // 初期状態は透明
        
        view.addSubview(popupLabel)
        
        // アニメーションで表示
        UIView.animate(withDuration: 0.3, animations: {
            popupLabel.alpha = 1 // 表示
        }) { _ in
            // 3秒後に自動的に消す
            UIView.animate(withDuration: 0.3, delay: 2.0, options: [], animations: {
                popupLabel.alpha = 0 // 非表示
            }) { _ in
                popupLabel.removeFromSuperview() // 画面から削除
            }
        }
    }
    
    func initButtons() {
        prevButton = UIButton()
        prevButton.setTitle("◀", for: .normal)
        prevButton.backgroundColor = .systemBlue
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
        view.addSubview(prevButton)
        
        nextButton = UIButton()
        nextButton.setTitle("▶", for: .normal)
        nextButton.backgroundColor = .systemBlue
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        view.addSubview(nextButton)
        
        // Auto LayoutでボタンをchartViewの下に横並びに配置
        NSLayoutConstraint.activate([
            prevButton.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 10),
            prevButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            prevButton.widthAnchor.constraint(equalToConstant: 80),
            prevButton.heightAnchor.constraint(equalToConstant: 40),
            
            nextButton.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 10),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 80),
            nextButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func initInfoLabel() {
        infoLabel = UILabel()
        infoLabel.text = "This is an info label"
        infoLabel.textAlignment = .center
        infoLabel.backgroundColor = .lightGray
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.numberOfLines = 0
        if UIDevice.current.userInterfaceIdiom == .pad {
            infoLabel.font = .boldSystemFont(ofSize: 26)
        } else {
            infoLabel.font = .boldSystemFont(ofSize: 16)
        }
        view.addSubview(infoLabel)
        
        // Auto Layoutでラベルをボタンの下に配置
        NSLayoutConstraint.activate([
            infoLabel.topAnchor.constraint(equalTo: prevButton.bottomAnchor, constant: 10),
            infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            //infoLabel.heightAnchor.constraint(equalToConstant: 40) // ラベルの高さを40に固定
        ])
    }
    
    /// 前の週に移動
    @objc func prevPage() {
        presenter.fillChartData(from: presenter.prev())
        presenter.updateButtonState()
        updateChart(with: presenter.chartData)
        updateLabel(avg:presenter.averageCount())
    }
    
    /// 次の週に移動
    @objc func nextPage() {
        presenter.fillChartData(from: presenter.next())
        presenter.updateButtonState()
        updateChart(with: presenter.chartData)
        updateLabel(avg:presenter.averageCount())
    }
    
}

extension DailyRecordViewController: DailyRecordPresenterOutput {
    func updateLabel(avg:(count: Double, minDate: String, maxDate: String)) {
        
        infoLabel.text = """
            \(avg.minDate) 〜 \(avg.maxDate)
            \n平均:\(avg.count)回
            """
    }
    
    func enableNextButton(_ isEnable: Bool) {
        setButtonState(nextButton, isEnable: isEnable)
    }
    
    func enablePrevButton(_ isEnable: Bool) {
        setButtonState(prevButton, isEnable: isEnable)
    }
    
    private func setButtonState(_ button: UIButton, isEnable: Bool) {
        button.isEnabled = isEnable
        button.backgroundColor = isEnable ? .systemBlue : .lightGray
        button.setTitleColor(isEnable ? .white : .darkGray, for: .normal)
    }
    
    func updateChart(with chartData: [(day: String, date: String, count: Int)]) {
        var dataEntries: [BarChartDataEntry] = []
        
        // データエントリの作成
        for (index, data) in chartData.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: Double(data.count))
            dataEntries.append(entry)
        }
        
        // BarChartDataSetの作成
        let dataSet = BarChartDataSet(entries: dataEntries, label: "Count")
        dataSet.colors = [NSUIColor.systemBlue]
        dataSet.valueFormatter = DefaultValueFormatter(formatter: NumberFormatter())
        dataSet.valueTextColor = .clear
        
        // グラフデータの作成
        let barChartData = BarChartData(dataSet: dataSet)
        barChartData.barWidth = 0.7
        
        // グラフにデータを設定
        chartView.data = barChartData
        
        // 曜日の表示用データを作成
        let displayDays = chartData.map { $0.day }

        // X軸の設定
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: displayDays)
        xAxis.labelCount = displayDays.count
        xAxis.granularity = 1
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .clear
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.labelRotationAngle = 0
        
        // グラフの更新を通知
        chartView.notifyDataSetChanged()
        
        initCustomXAxisLabels(with: chartData)
    }
   
    func initCustomXAxisLabels(with chartData: [(day: String, date: String, count: Int)]) {
        // 既存のカスタムラベルを削除
        for label in customXAxisLabels {
            label.removeFromSuperview()
        }
        customXAxisLabels.removeAll()
        
        let days = chartData.map { $0.day }
        
        // chartView のレイアウトが完了している必要があるため、レイアウト後に実行
        DispatchQueue.main.async {
            let chartWidth = self.chartView.bounds.width
            let labelHeight: CGFloat = 20
            let labelWidth = chartWidth / CGFloat(days.count)
            
            for (index, day) in days.enumerated() {
                let label = UILabel()
                label.text = day
                label.textAlignment = .center
                label.font = UIFont.systemFont(ofSize: 12)
                label.textColor = (day == "日") ? .red : (day == "土") ? .green : .white
                
                label.translatesAutoresizingMaskIntoConstraints = false // Auto Layoutを使用するために必要
                
                self.chartView.addSubview(label)
                self.customXAxisLabels.append(label)

                // Auto Layoutの制約を設定
                NSLayoutConstraint.activate([
                    label.bottomAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 5), // チャートの底からの距離
                    label.widthAnchor.constraint(equalToConstant: labelWidth), // 幅を設定
                    label.heightAnchor.constraint(equalToConstant: labelHeight), // 高さを設定
                    label.centerXAnchor.constraint(equalTo: self.chartView.leftAnchor, constant: CGFloat(index) * labelWidth + labelWidth / 2) // 各ラベルの水平位置
                ])
            }
        }
    }

}


