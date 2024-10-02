//
//  WeeklyRecordPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/09/20.
//

import Foundation

protocol WeeklyRecordPresenterInput: AnyObject {
    func viewWillAppear()
    func next()
    func prev()
    func fillChartData()
    func fetchChartData() -> [(weekNumber: String, count: Int)]
}

protocol WeeklyRecordPresenterOutput: AnyObject {
    func showChart(with dailyCounts: [String: Int])
    func enableNextButton(_ isEnable: Bool)
    func enablePrevButton(_ isEnable: Bool)
}

class WeeklyRecordPresenter {
    private weak var view: WeeklyRecordPresenterOutput?
    
    // グラフデータの基データ(全ての週番号が格納される)
    public var chartData: [(weekNumber: String, count: Int)] = []
    private let ONE_PAGE_DATA_MAX_COUNT = 5
    private var maxPage = 0
    private var currentPage = 0 //現在のページ
    
    private var calendar = Calendar(identifier: .gregorian)
    private var thisWeek: String // "yyyy-Www" 形式
    

    private let factory = CounterFactory()
    private var weeklyCounter: Counter!
    
    init(view: WeeklyRecordPresenterOutput, thisWeek: String, defaults: UserDefaults = .standard) {
        self.view = view
        self.thisWeek = thisWeek

        weeklyCounter = factory.create(type: .weekly, defaults: defaults)
    }
}


extension WeeklyRecordPresenter: WeeklyRecordPresenterInput {
    
    private func resetChartData(){
        maxPage = 0
        currentPage = 0
        for i in 0..<chartData.count {
            chartData[i].weekNumber = ""
            chartData[i].count = 0
        }
    }
    
    func fillChartData(){
        resetChartData()
        
        let minWeek = weeklyCounter.minDate()
        var currWeek = thisWeek
     
        while currWeek >= minWeek {
            let count = weeklyCounter.getCount(for: currWeek)
            chartData.append((weekNumber: currWeek, count: count))
            currWeek = DateManager.shared.previousWeek(from: currWeek)
        }
        
        // 5個単位になるよう調整
        let countToAdd = (ONE_PAGE_DATA_MAX_COUNT - (chartData.count % ONE_PAGE_DATA_MAX_COUNT)) % ONE_PAGE_DATA_MAX_COUNT // 追加すべき要素数を計算
        for _ in 0..<countToAdd {
            chartData.append((weekNumber: "", count: 0)) // 空白を追加
        }
        
        print("Debug WeeklyRecord baseData: \(chartData)")
        
        // 全ページ数を設定
        maxPage = chartData.count / ONE_PAGE_DATA_MAX_COUNT
    }

    func fetchChartData() -> [(weekNumber: String, count: Int)] {
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
    
    func viewWillAppear() {
        /*
        if let dailyCounts = UserDefaults.standard.dictionary(forKey: UserDefaultsKeys.DAILY_COUNT) as? [String: Int] {
            self.view?.showChart(with: dailyCounts)
        }
         */
    }
    
    func updateButtonState() {
 
        // nextボタンの制御
        self.view?.enableNextButton(currentPage > 0)
        
        // prevボタンの制御
        self.view?.enablePrevButton(currentPage < maxPage - 1)
        
    }


    

 

}

