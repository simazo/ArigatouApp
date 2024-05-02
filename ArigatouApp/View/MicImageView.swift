//
//  MicImageView.swift
//  ArigatouApp
//
//  Created by pero on 2024/05/03.
//

import UIKit

class MicImageView: UIImageView {
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startBounceAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.4
        animation.fromValue = 0.8
        animation.toValue = 1.0
        animation.autoreverses = true
        animation.repeatCount = .infinity
        layer.add(animation, forKey: "bounceAnimation")
    }
    
    func stopBounceAnimation() {
        layer.removeAllAnimations()
    }
}
