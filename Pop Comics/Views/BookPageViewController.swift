//
//  BookPageViewController.swift
//  Pop Comics
//
//  Created by justin on 6/2/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class BookPageViewController: UIViewController {

    @IBOutlet weak var pageImageView: UIImageView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var pageImage: UIImage?
    var delegate: BookViewDismissProtocol?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImageView.image = pageImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissBookView(_ sender: Any) {
        delegate?.dismissPageView()
    }

    @IBAction func toggleToolbarVisable(_ sender: Any) {
        if toolBar.isHidden {
                showToolbar()
        } else {
            hideToolbar()
        }
    }
    
    fileprivate func showToolbar() {
        UIView.animate(withDuration: 0.25, animations: {
            self.toolBar.isHidden = false
            self.toolBar.layer.opacity = 1
        }) { (complete) in
            self.timer = Timer.scheduledTimer(timeInterval: 5.0,
                                              target: self,
                                              selector: #selector(self.hideToolbar),
                                              userInfo: nil,
                                              repeats: false)
            
        }
    }
    
    @objc fileprivate func hideToolbar() {
        UIView.animate(withDuration: 0.5, animations: {
            self.toolBar.layer.opacity = 0
        }) { (complete) in
            if complete {
                self.toolBar.isHidden = true
                self.timer?.invalidate()
            }
        }
    }
}
