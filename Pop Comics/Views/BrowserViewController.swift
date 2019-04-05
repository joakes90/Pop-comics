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
    
    var comicMetadata: [Metadata]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.itemSize = CGSize(width: 150, height: 234)
        flowLayout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
     
    }

    func updateOpenPath(comicPath: ComicPath) {
        if comicPath.isDirectory {
            openComicDir(url: comicPath.url)
        } else {
            ProgressView.show()
            ComicManager.retreaveMetadata(for: [comicPath]) { (metaData) in
                let md = metaData.first
                let bookViewController = self.storyboard?.instantiateViewController(withIdentifier: "bookView") as? BookViewController
                bookViewController?.comicMetadata = md
                DispatchQueue.main.async {
                    self.present(bookViewController ?? BookViewController(),
                                 animated: true,
                                 completion: {
                                    ProgressView.hide()
                    })
                }
            }
        }
    }
    
    fileprivate func presentComicViewer(for destination: BookViewController) {
        guard let indexPath = collectionView.indexPathsForSelectedItems?.first,
            let selectedMetadata = comicMetadata?[indexPath.row] else {
                return
        }
        ProgressView.show()
        destination.comicMetadata  = selectedMetadata
    }
    
    fileprivate func openComicDir(url: URL) {
        ProgressView.show()
        FileController.shared.comicsIn(url: url) { (comics) in
            ComicManager.retreaveMetadata(for: comics, completion: { (metaData) in
                self.comicMetadata = metaData.sorted(by: { ($0.name ?? "AAA") < ($1.name ?? "BBB")})
                self.collectionView.reloadData()
                metaData.forEach({ $0.delegate = self })
                ProgressView.hide()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "presentViewer":
            if let destination = segue.destination as? BookViewController {
                presentComicViewer(for: destination)
            }
            break
        default:
            print("Am i ever called?")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension BrowserViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comicMetadata?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let metaData = comicMetadata else {
            return UICollectionViewCell()
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "comicCell", for: indexPath) as? ComicCollectionViewCell ?? ComicCollectionViewCell()
        let comic = metaData[indexPath.row]
        var coverImage: UIImage
        if let data = comic.coverImage,
            let dataImage = UIImage(data: data) {
            coverImage = dataImage
            cell.activityView.isHidden = true
            cell.activityView.stopAnimating()
        } else {
            coverImage = #imageLiteral(resourceName: "genaricComic")
            cell.activityView.isHidden = false
            cell.activityView.startAnimating()
            comic.populateCoverPage()
        }
        cell.coverImageView.image = coverImage
        return cell
    }
    
}

extension BrowserViewController: MetadataUpdateDelegate {
    
    func didUpdateCover(for object: Metadata) {
        if let cellIndex = comicMetadata?.firstIndex(of: object),
            let data = object.coverImage {
            let image = UIImage(data: data)
            let cell = collectionView.cellForItem(at: IndexPath(row: cellIndex, section: 0)) as? ComicCollectionViewCell
            cell?.coverImageView.image = image
            cell?.activityView.isHidden = true
            cell?.activityView.stopAnimating()
        }
    }
    
    
}
