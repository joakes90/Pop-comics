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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var comics: [ComicPath]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure collection View
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.itemSize = CGSize(width: 150, height: 234)
        flowLayout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
     
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
        ProgressView.show()
        FileController.shared.comicsIn(url: url) { (comics) in
            self.comics = comics
            self.collectionView.reloadData()
//            ProgressView.hide()
        }
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
        cell.coverImageView.image = comicPath.coverImage
        return cell
    }
    
}

extension BrowserViewController: UICollectionViewDelegate {

//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard let cell = cell as? ComicCollectionViewCell,
//        let comicPath = comics?[indexPath.row] else {
//            return
//        }
//        cell.nameLabel.text = comicPath.name
//        cell.retreaveMetaData(for: comicPath)
//    }
}
