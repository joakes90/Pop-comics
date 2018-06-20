//
//  CoverExtractOperation.swift
//  Pop Comics
//
//  Created by Justin Oakes on 19/6/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import Foundation

class CoverExtractOperation: Operation {
    
    let metaData: Metadata
    
    @objc init(metaData: Metadata) {
        self.metaData = metaData
        super.init()
    }
    
    override func main() {
        if self.isCancelled {
            return
        }
        metaData.processingCover = true
        guard let url = metaData.url,
            let comicURL = URL(string: url) else {
                metaData.processingCover = false
                return
        }
        let images  = ComicManager.openComic(at: comicURL.path)
        if let image = images?.first {
            let data = UIImagePNGRepresentation(image)
            metaData.coverImage = data
        }
        if metaData.delegate != nil {
            metaData.processingCover = false
            DispatchQueue.main.async {
                self.metaData.delegate?.didUpdateCover(for: self.metaData)
            }
        }

        if self.isCancelled {
            metaData.processingCover = false
            return
        }
        metaData.processingCover = false
    }
}
