//
//  BrowserViewController.swift
//  Pop Comics
//
//  Created by Justin Oakes on 22/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class BrowserViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var comics: [ComicPath]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func updateOpenPath(comicPath: ComicPath) {
        if comicPath.isDirectory {
            openComicDir(url: comicPath.url)
        } else {
            presentComicViewer()
        }
    }
    
    fileprivate func presentComicViewer() {
        print("open viwer")
    }
    
    fileprivate func openComicDir(url: URL) {
        comics = FileController.shared.comicsIn(url: url)
//        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let comicPath = comics![indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as? ComicCollectionViewCell ?? ComicCollectionViewCell()

        return cell
    }
    
}
