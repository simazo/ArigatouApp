//
//  VideoList.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/13.
//

public final class VideoList {
    static let items: [(count: Int, menu: String, url: String)] = [
        (count: 10, menu: "10回目の動画", url: "https://dancer.boo.jp/arigatou/mp4/space_travel_big.mp4"),
        (count: 100, menu: "100回目の動画", url: "aaa.mp4"),
    ]
    
    static func getUrl(_ count: Int) -> String? {
        if let item = items.first(where: { $0.count == count }) {
            return item.url
        }
        return nil
    }
    
    static func getMenu(_ count: Int) -> String? {
        if let item = items.first(where: { $0.count == count }) {
            return item.menu
        }
        return nil
    }
}

