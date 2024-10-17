//
//  NumberFormatManager.swift
//  ArigatouApp
//
//  Created by pero on 2024/10/17.
//

import Foundation

class NumberFormatManager {
    static let shared = NumberFormatManager()
    private init() {}
    func formatWithCommas(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal // 3桁区切りに設定
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}
