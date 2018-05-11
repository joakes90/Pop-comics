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
        let comicURL = Bundle.main.path(forResource: "All Star Superman 000", ofType: "cbr")
        let comicManager = ComicManager()
        let book = comicManager.openComic(at: comicURL!)
        testImageView.image = book?.first
    }
    
}

