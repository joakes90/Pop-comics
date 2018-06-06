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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollLeading: NSLayoutConstraint!
    @IBOutlet weak var scrollTrailing: NSLayoutConstraint!
    @IBOutlet weak var scrollTop: NSLayoutConstraint!
    @IBOutlet weak var scrollBottom: NSLayoutConstraint!
    
    
    var pageImage: UIImage?
    var delegate: BookViewDismissProtocol?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImageView.image = pageImage
    }
    
    fileprivate func updateMinScaleForSize(_ size: CGSize) {
        let widthScale = size.width / pageImageView.bounds.width
        let heightScale = size.height / pageImageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = 5
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinScaleForSize(view.bounds.size)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func dismissBookView(_ sender: Any) {
        delegate?.dismissPageView()
    }

    @IBAction func toggleToolbarVisable(_ sender: Any) {
//        if toolBar.isHidden {
//                showToolbar()
//        } else {
//            hideToolbar()
//        }
    }
    
    fileprivate func showToolbar() {
//        UIView.animate(withDuration: 0.25, animations: {
//            self.toolBar.isHidden = false
//            self.toolBar.layer.opacity = 1
//        }) { (complete) in
//            self.timer = Timer.scheduledTimer(timeInterval: 5.0,
//                                              target: self,
//                                              selector: #selector(self.hideToolbar),
//                                              userInfo: nil,
//                                              repeats: false)
//
//        }
    }
    
    @objc fileprivate func hideToolbar() {
//        UIView.animate(withDuration: 0.5, animations: {
//            self.toolBar.layer.opacity = 0
//        }) { (complete) in
//            if complete {
//                self.toolBar.isHidden = true
//                self.timer?.invalidate()
//            }
//        }
    }
}

extension BookPageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("zooming zooming zooming")
        return pageImageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
