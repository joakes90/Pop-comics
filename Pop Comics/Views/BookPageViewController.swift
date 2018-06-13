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
    @IBOutlet weak var aspectRatio: NSLayoutConstraint!
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet weak var pageLabel: UILabel!
    
    
    var pageImage: UIImage?
    var delegate: BookViewDismissProtocol?
    var index: Int?
    var pageNumber: Int?
    var totalPages: Int?
    var timer: Timer?
    weak var bookViewController: BookViewController?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pageImageView.image = pageImage
        pageLabel.text = "\(pageNumber ?? 0) of \(totalPages ?? 0)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let safeArea = view.safeAreaLayoutGuide.layoutFrame.size
        updateConstraintsForSize(safeArea)
        updateAspectRatioForSize(pageImage?.size ?? CGSize(width: 0, height: 0))
        updateMinScaleForSize(view.bounds.size)
    }
    fileprivate func updateAspectRatioForSize(_ size: CGSize) {
        let ratio = size.width/size.height
        aspectRatio.constant = ratio
        view.layoutIfNeeded()
    }
    
    fileprivate func updateMinScaleForSize(_ size: CGSize) {
        let safeArea = view.safeAreaLayoutGuide.layoutFrame.size
        updateConstraintsForSize(safeArea)
        let minWidthScale = size.width / pageImageView.bounds.width
        let minHeightScale = size.height / pageImageView.bounds.height
        let minScale = min(minWidthScale, minHeightScale)
        
        let maxWidthScale = size.width * 10
        let maxHeightScale = size.height * 10
        let maxScale = max(maxWidthScale, maxHeightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = minScale
        scrollView.maximumZoomScale = maxScale
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateMinScaleForSize(view.bounds.size)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
        if toolBar.isHidden {
                showToolbar()
        } else {
            hideToolbar()
        }
    }
    
    fileprivate func showToolbar() {
        toolBar.isHidden = false
        toolBar.layer.opacity = 0
        UIView.animate(withDuration: 0.5, animations: {
            self.toolBar.layer.opacity = 1
        }) { (complete) in
            self.toolBar.layer.opacity = 1
            self.timer = Timer.scheduledTimer(timeInterval: 3.0,
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PagesCollectionViewController {
            destination.book = bookViewController?.book
            destination.delegate = bookViewController
        }
    }
}

extension BookPageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return pageImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        let safeArea = view.safeAreaLayoutGuide.layoutFrame.size
//        updateConstraintsForSize(safeArea)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        let yOffset = max(0, (size.height - pageImageView.frame.height) / 2.0)
        scrollTop.constant = yOffset
        scrollBottom.constant = yOffset
//
        // not sure what the deal is with this divisor
            // just roll with it
        let xOffset = max(0, (size.width - pageImageView.frame.width) / 2.0)
        scrollLeading.constant = xOffset
        scrollTrailing.constant = xOffset
//        scrollView.contentOffset = CGPoint(x: xOffset, y: yOffset)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
}
