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

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DailyRecordPresenter(view: self)
        
        //initChart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //presenter.viewWillAppear()
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
