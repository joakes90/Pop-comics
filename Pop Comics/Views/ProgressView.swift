//
//  ProgressView.swift
//  Pop Comics
//
//  Created by Justin Oakes on 27/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    static let sharedInstance = ProgressView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4509242958)
    }
    private func show() {
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        frame = window.frame
        if superview != window {
            window.addSubview(self)
            window.bringSubview(toFront: self)
        }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        layer.add(animation, forKey: "fadeIn")
    }
    
    private func hide() {
        guard superview != nil else {
            return
        }
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        layer.add(animation, forKey: "fadeOut")
        self.removeFromSuperview()
    }
    static func show() {
        sharedInstance.show()
    }
    
    static func hide() {
        sharedInstance.hide()
    }
}
