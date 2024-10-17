//
//  MonthlyRecordPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/02.
//

import Foundation


protocol MonthlyRecordPresenterInput: AnyObject {
    func next()
    func prev()
    func fillChartData()
    func fetchChartData() -> [(yearMonth: String, count: Int)]
    func averageCount(with chartData: [(yearMonth: String, count: Int)]) -> (count: Double, minYearMonth: String, maxYearMonth: String)
}

protocol MonthlyRecordPresenterOutput: AnyObject {
    func updateLabel(avg:(count: Double, minYearMonth: String, maxYearMonth: String))
    func updateChart(with chartData: [(yearMonth: String, count: Int)])
    func enableNextButton(_ isEnable: Bool)
    func enablePrevButton(_ isEnable: Bool)
}

class MonthlyRecordPresenter {
    private weak var view: MonthlyRecordPresenterOutput?
    
    // グラフデータの基データ(全ての週番号が格納される)
    public var chartData: [(yearMonth: String, count: Int)] = []
    private let ONE_PAGE_DATA_MAX_COUNT = 5
    private var maxPage = 0
    private var currentPage = 0 //現在のページ
    
    private var calendar = Calendar(identifier: .gregorian)
    private var thisYearMonth: String // "yyyy-mm" 形式
    

    private let factory = CounterFactory()
    private var MonthlyCounter: Counter!
    
    init(view: MonthlyRecordPresenterOutput, thisYearMonth: String, defaults: UserDefaults = .standard) {
        self.view = view
        self.thisYearMonth = thisYearMonth

        MonthlyCounter = factory.create(type: .monthly, defaults: defaults)
    }
}

extension MonthlyRecordPresenter: MonthlyRecordPresenterInput {
    func averageCount(with chartData: [(yearMonth: String, count: Int)]) -> (count: Double, minYearMonth: String, maxYearMonth: String) {
        var totalCount = 0
        var validCountEntries = 0
        
        var minYearMonth: String = ""
        var maxYearMonth: String = ""
        
        for entry in chartData {
            if !entry.yearMonth.isEmpty {
                // count の合計を計算
                totalCount += entry.count
                validCountEntries += 1
                
                // minDateとmaxDateの設定
                if minYearMonth.isEmpty {
                    minYearMonth = entry.yearMonth
                    maxYearMonth = entry.yearMonth
                } else {
                    if entry.yearMonth < minYearMonth {
                        minYearMonth = entry.yearMonth
                    }
                    if entry.yearMonth > maxYearMonth {
                        maxYearMonth = entry.yearMonth
                    }
                }
            }
        }
        // 有効な count の平均を計算
        let averageCount = validCountEntries > 0 ? Double(totalCount) / Double(validCountEntries) : 0.0
            
        // 四捨五入して小数点第一位までにする
        let roundedAverageCount = round(averageCount * 10) / 10
            
        // フォーマット
        let minYearMonthJp = DateManager.shared.getjpYearMonth(from: minYearMonth)
        let maxYearMonthJp = DateManager.shared.getjpYearMonth(from: maxYearMonth)
        
        return (roundedAverageCount, minYearMonthJp, maxYearMonthJp)
    }
    
    
    private func resetChartData(){
        maxPage = 0
        currentPage = 0
        for i in 0..<chartData.count {
            chartData[i].yearMonth = ""
            chartData[i].count = 0
        }
    }
    
    func fillChartData(){
        resetChartData()
        
        let minMonth = MonthlyCounter.minDate()
        var currYearMonth = thisYearMonth
     
        while currYearMonth >= minMonth {
            let count = MonthlyCounter.getCount(for: currYearMonth)
            chartData.append((yearMonth: currYearMonth, count: count))
            currYearMonth = DateManager.shared.previousMonth(from: currYearMonth)
        }
        
        // 5個単位になるよう調整
        let countToAdd = (ONE_PAGE_DATA_MAX_COUNT - (chartData.count % ONE_PAGE_DATA_MAX_COUNT)) % ONE_PAGE_DATA_MAX_COUNT // 追加すべき要素数を計算
        for _ in 0..<countToAdd {
            chartData.append((yearMonth: "", count: 0)) // 空白を追加
        }
        
        //print("Debug MonthlyRecord chartData: \(chartData)")
        
        // 全ページ数を設定
        maxPage = chartData.count / ONE_PAGE_DATA_MAX_COUNT
    }

    func fetchChartData() -> [(yearMonth: String, count: Int)] {
        var startIndex = 0
        var endIndex = ONE_PAGE_DATA_MAX_COUNT - 1
        let addCount = ONE_PAGE_DATA_MAX_COUNT * currentPage
        
        startIndex += addCount
        endIndex += addCount
        
        return Array(chartData[startIndex...endIndex])
    }
    
    // 現在の週番号のページに向かう
    func next() {
        currentPage -= 1
    }
    
    // 古い週番号のページに向かう
    func prev() {
        currentPage += 1
    }
    
    func updateButtonState() {
 
        // nextボタンの制御
        self.view?.enableNextButton(currentPage > 0)
        
        // prevボタンの制御
        self.view?.enablePrevButton(currentPage < maxPage - 1)
        
    }


    

 

}
