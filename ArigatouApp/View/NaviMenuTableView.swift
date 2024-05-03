//
//  NaviMenuTableView.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/03.
//

import UIKit

class NaviMenuTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var items: [String] = []
    var selectedItem: String?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.dataSource = self
        self.delegate = self
        self.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
    
    // MARK: - TableView Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        // 選択されたアイテムに対する任意の処理を実行
        print("選択されたアイテム：", selectedItem ?? "")
        
        // プルダウンメニューを閉じる場合は、選択後のアクションを実行する
        // 例： self.dismiss(animated: true, completion: nil)
    }
}
