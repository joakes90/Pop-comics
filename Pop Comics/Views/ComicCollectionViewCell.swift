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
    fileprivate var comicPath: ComicPath?
    var metaData: Metadata?
    
    func retreaveMetaData(for comicPath: ComicPath) {
        self.comicPath = comicPath
        ComicManager.retreaveMetadata(for: comicPath) { (metadata) in
            self.metaData = metadata
            guard let metadata = metadata,
                let coverImageData = metadata.coverImage else {
                    return
            }
            let coverImage =  UIImage(data: coverImageData) ?? #imageLiteral(resourceName: "genaricComic")
            self.coverImageView.image = coverImage
        }
    }
    
}
