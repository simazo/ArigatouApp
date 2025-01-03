//
//  WeeklyRecordView.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/08.
//

import UIKit
import DGCharts


class WeeklyRecordViewController: UIViewController, ChartViewDelegate {
    private var chartView: BarChartView!
    private var presenter: WeeklyRecordPresenter!
    
    var infoLabel: UILabel!
    var prevButton: UIButton!
    var nextButton: UIButton!
    
    private var customXAxisLabels: [UILabel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let thisWeek = DateManager.shared.formattedWeekString()
        presenter = WeeklyRecordPresenter(view: self, thisWeek: thisWeek) //初期値は現在の週番号
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initChartView()
        initButtons()
        initInfoLabel()
        
        presenter.fillChartData()
        let fetchedData = presenter.fetchChartData()
        presenter.updateButtonState()
        updateChart(with: fetchedData)
        updateLabel(avg:presenter.averageCount(with: fetchedData),
                    calorie: presenter.caloriesBurned())
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
        
        let fetchedData = presenter.fetchChartData()
        let week = fetchedData[index]

        let count = week.count // カウント
        let weekNumber = week.weekNumber // 週番号
        
        // カスタムポップアップの表示
        if !weekNumber.isEmpty { showCustomPopup(withCount: count, weekNumber: weekNumber) }
    }
    
    func showCustomPopup(withCount count: Int, weekNumber: String) {
        let popupLabel = UILabel()
        popupLabel.text = "\(weekNumber)\n\(count)回"
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
    
    /// 前のページに移動
    @objc func prevPage() {
        presenter.prev()
        let fetchedData = presenter.fetchChartData()
        updateChart(with: fetchedData)
        
        presenter.updateButtonState()
        updateLabel(avg:presenter.averageCount(with: fetchedData),
                    calorie: presenter.caloriesBurned())
    }
    
    /// 次のページに移動
    @objc func nextPage() {
        presenter.next()
        let fetchedData = presenter.fetchChartData()
        updateChart(with: fetchedData)
        
        presenter.updateButtonState()
        updateLabel(avg:presenter.averageCount(with: fetchedData),
                    calorie: presenter.caloriesBurned())
    }
}

extension WeeklyRecordViewController: WeeklyRecordPresenterOutput {
 
    func updateLabel(avg:(sum: Int, count: Double, minWeek: String, maxWeek: String),
                     calorie:(sumCalorie: Double, avgCalorie: Double)) {
        
        let sumString = NumberFormatManager.shared.formatWithCommas(Double(avg.sum))
        let averageString = NumberFormatManager.shared.formatWithCommas(avg.count)
        let sumCalorieString = NumberFormatManager.shared.formatWithCommas(calorie.sumCalorie / 1000)
        let avgCalorieString = NumberFormatManager.shared.formatWithCommas(calorie.avgCalorie / 1000)
        
        infoLabel.text = """
            \(avg.minWeek) 〜 \(avg.maxWeek)
            \n合計 : \(sumString) 回 (平均 : \(averageString) 回)
            \n\(sumCalorieString) kcal (平均 : \(avgCalorieString) kcal)
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
    
    func updateChart(with chartData: [(weekNumber: String, count: Int)]) {
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
        
        let weeks = chartData.map { data in
            DateManager.shared.getWeekNumber(from: data.weekNumber)
        }

        // X軸の設定
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: weeks)
        xAxis.labelCount = weeks.count
        xAxis.granularity = 1
        xAxis.labelPosition = .bottom
        
        xAxis.labelTextColor = .white
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.labelRotationAngle = 0
        
        // グラフの更新を通知
        chartView.notifyDataSetChanged()
    }

    
}
