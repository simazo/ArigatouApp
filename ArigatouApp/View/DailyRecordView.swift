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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DailyRecordPresenter(view: self, today: Date()) //初期値は現在日
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //presenter.viewWillAppear()
        
        initChartView()
        initButtons()
        initInfoLabel()
        presenter.fillChartData(from: Date()) //初期値は現在日
        presenter.updateButtonState()
        updateChart(with: presenter.chartData)
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
        
        chartView.doubleTapToZoomEnabled = false // ダブルタップでのズームを無効化
        chartView.pinchZoomEnabled = false // ピンチズームを無効化
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
 
        guard let barEntry = entry as? BarChartDataEntry else { return }
        let count = Int(barEntry.y) // 選択されたデータのカウントを取得
        
        // カスタムポップアップの表示
        showCustomPopup(withCount: count)
    }
    
    func showCustomPopup(withCount count: Int) {
        let popupLabel = UILabel()
        popupLabel.text = "Count: \(count)"
        popupLabel.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        popupLabel.textColor = .white
        popupLabel.textAlignment = .center
        popupLabel.layer.cornerRadius = 8
        popupLabel.layer.masksToBounds = true
        popupLabel.numberOfLines = 1
        
        // ラベルのサイズと位置を設定
        popupLabel.frame.size = CGSize(width: 150, height: 40)
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
        prevButton.setTitle("Prev", for: .normal)
        prevButton.backgroundColor = .systemBlue
        prevButton.translatesAutoresizingMaskIntoConstraints = false
        prevButton.addTarget(self, action: #selector(prevPage), for: .touchUpInside)
        view.addSubview(prevButton)
        
        nextButton = UIButton()
        nextButton.setTitle("Next", for: .normal)
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
    }
    
    /// 次の週に移動
    @objc func nextPage() {
        presenter.fillChartData(from: presenter.next())
        presenter.updateButtonState()
        updateChart(with: presenter.chartData)
    }
    
}

extension DailyRecordViewController: DailyRecordPresenterOutput {
    func enableNextButton(_ isEnable: Bool) {
        nextButton.isEnabled = isEnable
    }
    
    func enablePrevButton(_ isEnable: Bool) {
        prevButton.isEnabled = isEnable
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
        
        // mm/dd形式で日付を表示するフォーマッタを設定
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd" // 既存の日付形式
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.dateFormat = "MM/dd" // 表示する形式
        
        // 日付の表示用データを作成
        let displayDates = chartData.compactMap { data -> String? in
            guard let date = inputDateFormatter.date(from: data.date) else { return nil }
            return outputDateFormatter.string(from: date)
        }
        
        // X軸の設定
        let xAxis = chartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: displayDates)
        xAxis.labelCount = displayDates.count // X軸のラベル数を設定
        xAxis.granularity = 1
        
        // グラフの更新を通知
        chartView.notifyDataSetChanged()
    }
    
}
