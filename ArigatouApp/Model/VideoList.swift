//
//  VideoList.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/13.
//

public final class VideoList {
    static let items: [(count: Int, menu: String, url: String)] = [
        //(count: 10, menu: "10回目の動画", url: "https://dancer.boo.jp/arigatou/mp4/space_travel_big.mp4"),
        (count: 100, menu: "100回目の動画", url: "https://dancer.boo.jp/arigatou/mp4/space_travel_big.mp4"),
        (count: 1000, menu: "1,000回目の動画", url: "https://dancer.boo.jp/arigatou/mp4/space_travel_big.mp4"),
        (count: 5000, menu: "5,000回目の動画", url: "https://dancer.boo.jp/arigatou/mp4/space_travel_big.mp4"),
        (count: 10000, menu: "10,000回目の動画", url: "https://dancer.boo.jp/arigatou/mp4/space_travel_big.mp4"),
        (count: 50000, menu: "50,000回目の動画", url: "aaa.mp4"),
        (count: 100000, menu: "100,000回目の動画", url: "aaa.mp4"),
        (count: 500000, menu: "500,000回目の動画", url: "aaa.mp4"),
        (count: 1000000, menu: "1000,000回目の動画", url: "aaa.mp4"),
    ]
    
    static func getUrlByCount(_ count: Int) -> String? {
        if let item = items.first(where: { $0.count == count }) {
            return item.url
        }
        return nil
    }
    
    static func getUrlByMenu(_ menu: String) -> String? {
        if let item = items.first(where: { $0.menu == menu }) {
            return item.url
        }
        return nil
    }

    static func getMenuByCount(_ count: Int) -> String? {
        if let item = items.first(where: { $0.count == count }) {
            return item.menu
        }
        return nil
    }
    
    /// 指定されたマッチ数以下の動画メニューを取得します。
    ///
    /// - Parameters:
    ///   - matchCount: マッチ数
    /// - Returns: マッチした動画メニューの配列。マッチしない場合は空の配列。
    static func getMatchMenus(matchCount: Int) -> [String] {
        let matchedMenus = items.filter { $0.count <= matchCount }.map { $0.menu }
        return matchedMenus.isEmpty ? [] : matchedMenus
    }

}

