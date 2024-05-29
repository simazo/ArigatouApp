//
//  VideoList.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/13.
//

import Foundation

struct VideoItem: Codable {
    let count: Int
    let menu: String
    let url: String
}

public final class VideoList {
    private(set) var items: [VideoItem] = []
    static let shared = VideoList()
    private init() {
        loadItems()
    }
    
    private func loadItems() {
        if let url = Bundle.main.url(forResource: "videos", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                items = try decoder.decode([VideoItem].self, from: data)
            } catch {
                print("Error loading or parsing videos.json: \(error)")
            }
        } else {
            print("videos.json not found")
        }
    }
    
    func getUrlByCount(_ count: Int) -> String? {
        if let item = items.first(where: { $0.count == count }) {
            return item.url
        }
        return nil
    }
    
    func getUrlByMenu(_ menu: String) -> String? {
        if let item = items.first(where: { $0.menu == menu }) {
            return item.url
        }
        return nil
    }

    func getMenuByCount(_ count: Int) -> String? {
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
    func getMatchMenus(matchCount: Int) -> [String] {
        let matchedMenus = items.filter { $0.count <= matchCount }.map { $0.menu }
        return matchedMenus.isEmpty ? [] : matchedMenus
    }

}

