//
//  ComicManager.swift
//  Pop Comics
//
//  Created by Justin Oakes on 6/3/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import NVHTarGzip
import UIKit
import UnrarKit
import Zip
typealias Book = [UIImage]

enum extensions: String {
    typealias RawValue = String
    
    case cbr = "cbr"
    case cbt = "cbt"
    case cbz = "cbz"
}
class ComicManager {
    
    func openComic(at path: String) -> Book? {
        let url = URL(fileURLWithPath: path)
        guard let ext = extensions(rawValue: url.pathExtension) else {
            return nil
        }
        switch ext {
        case .cbr:
            return expandCBR(url: url)
        case .cbz:
            return expandCBZ(url: url)
        case .cbt:
            return expandCBT(url: url)
        }
    }
    
    
    fileprivate func expandCBZ(url: URL) -> Book? {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let comicDir = tempDir.appendingPathComponent(url.lastPathComponent)
        var expandedImagePaths = [String]()
        do {
            try fileManager.createDirectory(at: comicDir,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
            try Zip.unzipFile(url, destination: comicDir, overwrite: true, password: nil)
            let fileNames = try fileManager.contentsOfDirectory(atPath: comicDir.path).sorted()
            fileNames.forEach { (file) in
                expandedImagePaths.append(comicDir.appendingPathComponent(file).path)
            }
            var book: Book?
            for path in expandedImagePaths {
                if let image = UIImage(contentsOfFile: path) {
                    if book == nil {book = Book()}
                    book?.append(image)
                }
            }
            
            return book
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    fileprivate func expandCBT(url: URL) -> Book? {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let comicDir = tempDir.appendingPathComponent(url.lastPathComponent)
        var expandedImagePaths = [String]()
        do {
            try fileManager.createDirectory(at: comicDir,
                                        withIntermediateDirectories: true,
                                        attributes: nil)
            try NVHTarGzip.sharedInstance().unTarFile(atPath: url.path, toPath: comicDir.path)
            let fileNames = try fileManager.contentsOfDirectory(atPath: comicDir.path).sorted()
            fileNames.forEach { (file) in
                expandedImagePaths.append(comicDir.appendingPathComponent(file).path)
            }
            var book: Book?
            for path in expandedImagePaths {
                if let image = UIImage(contentsOfFile: path) {
                    if book == nil {book = Book()}
                    book?.append(image)
                }
            }
            return book
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    fileprivate func expandCBR(url: URL) -> Book? {
        do {
            var book: Book?
            let cbrArchive = try URKArchive(url: url)
            let comicFiles = try cbrArchive.listFilenames().sorted()
            for file in comicFiles {
                let fileData = try cbrArchive.extractData(fromFile: file, progress: nil)
                if let image = UIImage(data: fileData) {
                    if book == nil {book = Book()}
                    book?.append(image)
                }
            }
            return book
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
