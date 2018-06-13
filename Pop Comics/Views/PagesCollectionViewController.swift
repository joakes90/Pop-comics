//
//  PagesCollectionViewController.swift
//  Pop Comics
//
//  Created by Justin Oakes on 12/6/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class PagesCollectionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var book: Book?
    var delegate: skipPageManagment?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 2.0
        flowLayout.itemSize = CGSize(width: 150, height: 234)
        flowLayout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        collectionView.collectionViewLayout = flowLayout
        // Do any additional setup after loading the view.
    }

}

extension PagesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return book?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pageCell", for: indexPath) as? PageCollectionViewCell ?? PageCollectionViewCell()
        cell.pageImageview.image = book?[indexPath.row] ?? #imageLiteral(resourceName: "genaricComic")
        return cell
    }
    
    
}

extension PagesCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        delegate?.skipTo(page: indexPath.row)
    }
}

protocol skipPageManagment {
    func skipTo(page: Int)
}
