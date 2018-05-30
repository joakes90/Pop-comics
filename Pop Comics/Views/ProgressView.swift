//
//  ProgressView.swift
//  Pop Comics
//
//  Created by Justin Oakes on 27/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class ProgressView: UIView {
    
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
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
        Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)
        backgroundView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(backgroundView)
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
        growAnimation(on: imageView, for: 0.25)
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
    
    private func spinAnimation(on view: UIView, for duration: CGFloat, rotations: CGFloat) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.shrinkAnimation(on: self.imageView, for: 0.25)
        }
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.toValue = CGFloat.pi * 2.0 * rotations
        animation.duration = Double(duration) as CFTimeInterval
        animation.isCumulative = true
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(animation, forKey: "spinAnimation")
        CATransaction.commit()
    }
    
    func shrinkAnimation(on view: UIView, for duration: CGFloat) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.imageView.layer.transform = CATransform3DMakeScale(0.575, 0.575, 0.575)
            self.growAnimation(on: self.imageView, for: 0.25)
        }
        let animation = CABasicAnimation(keyPath: "transform")
        let transform = CATransform3DMakeScale(0.575, 0.575, 0.575)
        animation.toValue = transform
        animation.duration = Double(duration) as CFTimeInterval
        animation.isCumulative = true
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(animation, forKey: "shrinkAnimation")
        CATransaction.commit()
    }
    
    func growAnimation(on view: UIView, for duration: CGFloat) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.imageView.layer.transform = CATransform3DMakeScale(1.75, 1.75, 1.75)
            self.spinAnimation(on: self.imageView, for: 1.5, rotations: 3.0)
        }
        let animation = CABasicAnimation(keyPath: "transform")
        let transform = CATransform3DMakeScale(1.75, 1.75, 1.75)
        animation.toValue = transform
        animation.duration = Double(duration) as CFTimeInterval
        animation.isCumulative = true
        animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        view.layer.add(animation, forKey: "growAnimation")
        CATransaction.commit()
    }
    static func show() {
        sharedInstance.show()
    }
    
    static func hide() {
        sharedInstance.hide()
    }
}

extension ProgressView {
    func addImageConstraints() -> [NSLayoutConstraint]{
        let centerVertically = NSLayoutConstraint(item: imageView,
                                                  attribute: .centerY,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: .centerY,
                                                  multiplier: 1.0,
                                                  constant: 0)
        let centerHorizonyally = NSLayoutConstraint(item: imageView,
                                                    attribute: .centerX,
                                                    relatedBy: .equal,
                                                    toItem: self,
                                                    attribute: .centerX,
                                                    multiplier: 1.0,
                                                    constant: 0)
        return [centerVertically,centerHorizonyally]
    }
}
