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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstTimeRun()
    }

    private func firstTimeRun() {
        if UserDefaults.standard.bool(forKey: "initialConfig") != true {
            let alert = UIAlertController(title: NSLocalizedString("Enable iCloud", comment: "title for alert asking for iCloud permission"),
                                          message: NSLocalizedString("Enabling iCloud makes importing your comics from your Mac or other iOS devices effortless", comment: "message for alert asking for iCloud permission"),
                                          preferredStyle: .alert)
            let sureButton = UIAlertAction(title: NSLocalizedString("Sure", comment: "sure"),
                                           style: .default,
                                           handler: nil)
            let cancelButton = UIAlertAction(title: NSLocalizedString("Maybe later", comment: "maybe later"),
                                             style: .cancel,
                                             handler: nil)
            alert.addAction(sureButton)
            alert.addAction(cancelButton)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

