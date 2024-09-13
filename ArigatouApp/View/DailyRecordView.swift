//
//  DailyRecordView.swift
//  ArigatouApp
//
//  Created by pero on 2024/07/15.
//

import UIKit
import DGCharts

class DailyRecordViewController: UIViewController {
    
    private var chartView: LineChartView!
    private var presenter: DailyRecordPresenter!

    var prevButton: UIButton!
    var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DailyRecordPresenter(view: self, today: Date()) //初期値は現在日
        
        //initChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //presenter.viewWillAppear()
        
        initNextButton()
        initPrevButton()
        presenter.fillChartData(from: Date()) //初期値は現在日
        presenter.updateButtonState()
    }
    
    func initNextButton(){
        nextButton = UIButton(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.addTarget(self, action: #selector(nextWeek), for: .touchUpInside)
        nextButton.frame = CGRect(x: 250, y: 600, width: 100, height: 50)
        view.addSubview(nextButton)
    }
    
    func initPrevButton(){
        prevButton = UIButton(type: .system)
        prevButton.setTitle("Prev", for: .normal)
        prevButton.addTarget(self, action: #selector(prevWeek), for: .touchUpInside)
        prevButton.frame = CGRect(x: 50, y: 600, width: 100, height: 50)
        view.addSubview(prevButton)
    }
    
    /// 前の週に移動
    @objc func prevWeek() {
        presenter.fillChartData(from: presenter.prev())
        presenter.updateButtonState()
    }
    
    /// 次の週に移動
    @objc func nextWeek() {
        presenter.fillChartData(from: presenter.next())
        presenter.updateButtonState()
    }
    
    func initChart() {
        chartView = LineChartView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.xAxis.drawLabelsEnabled = false
        self.view.addSubview(chartView)
        
        let padding: CGFloat = 60.0 //余白
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.topAnchor, constant: padding),
            chartView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding)
        ])
    }
    
}

extension DailyRecordViewController: DailyRecordPresenterOutput {
    func enableNextButton(_ isEnable: Bool) {
        nextButton.isEnabled = isEnable
    }
    
    func enablePrevButton(_ isEnable: Bool) {
        prevButton.isEnabled = isEnable
    }
    
    func showChart(with dailyCounts: [String : Int]) {
        var entries: [ChartDataEntry] = []
        // データをChartDataEntryに変換
        for (index, element) in dailyCounts.enumerated() {
            _ = element.key
            let value = element.value
            entries.append(ChartDataEntry(x: Double(index), y: Double(value)))
        }
        let dataSet = LineChartDataSet(entries: entries, label: "Daily Counts")
        

        dataSet.valueTextColor = .white // 数値の色
        dataSet.valueFont = .systemFont(ofSize: 10) // 数値のフォント
        
        let data = LineChartData(dataSet: dataSet)
        chartView.data = data
    }
}
