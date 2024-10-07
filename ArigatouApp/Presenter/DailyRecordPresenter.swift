//
//  DailyRecordPresenter.swift
//  ArigatouApp
//
//  Created by pero on 2024/07/15.
//

import Foundation

protocol DailyRecordPresenterInput: AnyObject {
    func next() -> Date
    func prev() -> Date
    func fillChartData(from baseDate: Date)
    func averageCount() -> (count: Double, minDate: String, maxDate: String)
}

protocol DailyRecordPresenterOutput: AnyObject {
    func updateLabel(avg:(count: Double, minDate: String, maxDate: String))
    func updateChart(with chartData: [(day: String, date: String, count: Int)])
    func enableNextButton(_ isEnable: Bool)
    func enablePrevButton(_ isEnable: Bool)
}

class DailyRecordPresenter {
    private weak var view: DailyRecordPresenterOutput?
    
    public var chartData: [(day: String, date: String, count: Int)] = [
        ("日", "", 0),
        ("月", "", 0),
        ("火", "", 0),
        ("水", "", 0),
        ("木", "", 0),
        ("金", "", 0),
        ("土", "", 0)
    ]

    private var calendar = Calendar(identifier: .gregorian)
    private var today: Date
    private var currentDate: Date

    private let factory = CounterFactory()
    private var dailyCounter: Counter!
    
    init(view: DailyRecordPresenterOutput, today: Date = Date(), defaults: UserDefaults = .standard) {
        self.view = view
        self.today = today //ユニットテストのためDI
        self.currentDate = today

        dailyCounter = factory.create(type: .daily, defaults: defaults)
    }
}

extension DailyRecordPresenter: DailyRecordPresenterInput {
    func averageCount() -> (count: Double, minDate: String, maxDate: String) {
        var totalCount = 0
        var validCountEntries = 0
        
        var minDate: String = ""
        var maxDate: String = ""
        
        for entry in chartData {
            if !entry.date.isEmpty {
                // count の合計を計算
                totalCount += entry.count
                validCountEntries += 1
                
                // minDateとmaxDateの設定
                if minDate.isEmpty {
                    minDate = entry.date
                    maxDate = entry.date
                } else {
                    if entry.date < minDate {
                        minDate = entry.date
                    }
                    if entry.date > maxDate {
                        maxDate = entry.date
                    }
                }
            }
        }
        // 有効な count の平均を計算
        let averageCount = validCountEntries > 0 ? Double(totalCount) / Double(validCountEntries) : 0.0
            
        // 四捨五入して小数点第一位までにする
        let roundedAverageCount = round(averageCount * 10) / 10
            
        // フォーマット
        let minDateJP = DateManager.shared.japaneseFormattedDate(from: minDate)
        let maxDateJP = DateManager.shared.japaneseFormattedDate(from: maxDate)
        
        // minDateとmaxDateは必ず値が設定されている
        return (roundedAverageCount, minDateJP, maxDateJP)
    }
    
    /// currentDateの１週間後の日付を返す
    func next() -> Date {
        currentDate =  calendar.date(byAdding: .day, value: 7, to: currentDate)!
        return currentDate
    }
    
    /// currentDateの１週間前の日付を返す
    func prev() -> Date {
        currentDate = calendar.date(byAdding: .day, value: -7, to: currentDate)!
        return currentDate
    }
    
    /// chartDataに日付とカウント数を設定する
    func fillChartData(from baseDate: Date){
        fillDate(from: baseDate)
        fillCount()
        //print("Debug DailyRecord chartData: \(chartData)")
    }
    
    /// ボタン制御
    func updateButtonState() {
        let todayStart = calendar.startOfDay(for: today)
        let currentDay = calendar.startOfDay(for: currentDate)

        // nextボタンの制御: 現在日まで達したら無効化
        self.view?.enableNextButton(currentDay < todayStart)
        
        // prevボタンの制御: UserDefaults内の最も古い日付まで達したら無効化
        let earliestDate = DateManager.shared.formattedDate(dailyCounter.minDate())
        let earliestDay = calendar.startOfDay(for: earliestDate)
        
        // 最古の日付まで到達したかを確認する
        if chartData.first?.date == "" || chartData.first?.date == nil {
            // 空の日付が最初に来たら prev ボタンを無効化
            self.view?.enablePrevButton(false)
        } else {
            // 最古の日付より後であれば prev ボタンを有効化
            self.view?.enablePrevButton(currentDay > earliestDay)
        }
        
        //print("Debug DailyRecord chartData: \(chartData)")
    }

    /// chartDataの初期化
    private func resetChartData() {
        for i in 0..<chartData.count {
            chartData[i].date = ""
            chartData[i].count = 0
        }
    }
    
    /// 指定された日付を含む週の日曜から土曜までの日付を取得し、その日付情報を chartData に格納します。日付の範囲は、最古の日付（minDate）や現在日（today）を超えないように制限されます。このメソッドは週の中の基準日を基に、それ以前（日曜方向）とそれ以降（土曜方向）の日付を埋めます。
    /// - Parameter baseDate: 基準となる日付
    private func fillDate(from baseDate: Date) {
        resetChartData()

        let minDateString = dailyCounter.minDate()
        let minDate = DateManager.shared.formattedDate(minDateString)
        
        var currentDate = baseDate
        
        // 曜日のインデックスが 1（日曜日）から始まるため配列に合わせてマイナス１する
        let currentWeekdayIndex = calendar.component(.weekday, from: currentDate) - 1
        // 基準日をセット
        chartData[currentWeekdayIndex].date = DateManager.shared.formattedDateString(date: currentDate)

        // 基準日から日曜に向かって日付をセット
        for i in stride(from: currentWeekdayIndex, to: 0, by: -1) {
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            
            // 最古の日付より前の場合、空白にして処理を中断
            if currentDate < minDate {
                chartData[i - 1].date = ""
                break
            }
            chartData[i - 1].date = DateManager.shared.formattedDateString(date: currentDate)
        }
        
        // 基準日から土曜までの日付をセット、現在日を超えないようにする
        currentDate = baseDate
        for i in currentWeekdayIndex..<chartData.count - 1 {
            guard let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate),
                  calendar.startOfDay(for: nextDate) <= today else {
                break
            }
            currentDate = nextDate
            chartData[i + 1].date = DateManager.shared.formattedDateString(date: currentDate)
        }
    }
    
    /// UserDefaultsのカウント数をchartDataにセットする
    private func fillCount() {
        for i in 0..<chartData.count {
            let count = dailyCounter.getCount(for: chartData[i].date)
            chartData[i].count = count
        }
    }
}

