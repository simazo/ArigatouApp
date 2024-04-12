//
//  PaddingLabel.swift
//  ArigatouApp
//
//  Created by pero on 2024/04/12.
//

import UIKit

class PaddingLabel: UILabel {
    let insets: UIEdgeInsets

    init(insets: UIEdgeInsets) {
        self.insets = insets
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }

    override open var intrinsicContentSize: CGSize {
        var intrinsicContentSize = super.intrinsicContentSize
        intrinsicContentSize.width += (insets.left + insets.right)
        intrinsicContentSize.height += (insets.top + insets.bottom)
        return intrinsicContentSize
    }
}
