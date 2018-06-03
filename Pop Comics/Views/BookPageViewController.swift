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
    var pageImage: UIImage?
    var delegate: BookViewDismissProtocol?
    
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

}
