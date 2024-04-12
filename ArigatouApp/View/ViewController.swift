//
//  ViewController.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    
    private var presenter: PresenterInput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SpeechPresenter(view: self)
        presenter.viewDidLoad()
    }
}
extension ViewController: PresenterOutput{
    func refreshLabelText(text: String) {
        DispatchQueue.main.async {
            self.label.text = text
        }
    }
}

