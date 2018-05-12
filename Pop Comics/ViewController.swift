//
//  ViewController.swift
//  Pop Comics
//
//  Created by Justin Oakes on 6/3/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var testImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func test(_ sender: Any) {
        let comicURL = Bundle.main.path(forResource: "Alias 002 (2001) (FBScan) - Unknown", ofType: "pdf")
        let comicManager = ComicManager()
        let book = comicManager.openComic(at: comicURL!)
        testImageView.image = book?.last
    }
    
}

