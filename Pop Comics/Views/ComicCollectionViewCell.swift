//
//  ComicCellCollectionViewCell.swift
//  Pop Comics
//
//  Created by Justin Oakes on 15/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    fileprivate var fileURL: URL?
    
    func retreaveMetaData(for comicPath: ComicPath) {
        fileURL = comicPath.url
    }
    
}
