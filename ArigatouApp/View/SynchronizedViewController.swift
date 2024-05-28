//
//  SynchronizedViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/28.
//

import UIKit

class SynchronizedViewController: UIViewController {
    private var presenter: SynchronizedPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SynchronizedPresenter(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}
extension SynchronizedViewController: SynchronizedPresenterOutput {
    
}
