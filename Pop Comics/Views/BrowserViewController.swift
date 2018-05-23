//
//  BrowserViewController.swift
//  Pop Comics
//
//  Created by Justin Oakes on 22/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOpenBook(aNotification:)),
                                               name: Notification.openDir,
                                               object: nil)
        // Do any additional setup after loading the view.
    }

    @objc func updateOpenBook(aNotification: Notification) {
        guard let userInfo = aNotification.userInfo,
            let comicPath = userInfo["path"] as? ComicPath else {
                return
        }
        if comicPath.isDirectory {
            openComicDir()
        } else {
            presentComicViewer()
        }
    }
    
    fileprivate func presentComicViewer() {
        print("open viwer")
    }
    
    fileprivate func openComicDir() {
        print("open dir")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}
