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
    
    case cbr
    case CBR
    case cbt
    case CBT
    case cbz
    case CBZ
    case pdf
    case PDF
}
class ComicManager {
    
    static func openComic(at path: String) -> Book? {
        let url = URL(fileURLWithPath: path)
        guard let ext = extensions(rawValue: url.pathExtension) else {
            return nil
        }
        switch ext {
        case .cbr, .CBR:
            return expandCBR(url: url)
        case .cbz, .CBZ:
            return expandCBZ(url: url)
        case .cbt, .CBT:
            return expandCBT(url: url)
        case .pdf, .PDF:
            return  expandPDF(url: url)
        }
    }
    
    
    fileprivate static func expandCBZ(url: URL) -> Book? {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let comicDir = tempDir.appendingPathComponent(url.lastPathComponent.lowercased())
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
    
    fileprivate static func expandCBT(url: URL) -> Book? {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let comicDir = tempDir.appendingPathComponent(url.lastPathComponent.lowercased())
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
    
    fileprivate static func expandCBR(url: URL) -> Book? {
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
    
    fileprivate static func expandPDF(url: URL) -> Book? {
        do {
            let data = try Data(contentsOf: url) as CFData
            guard let provider = CGDataProvider(data: data),
            let pdf = CGPDFDocument(provider) else {
                return nil
            }
            // converting the pages
            var book: Book?
            for i in 1...pdf.numberOfPages {
                guard let page = pdf.page(at: i) else {
                    break
                }
                let pageSize = page.getBoxRect(.mediaBox).size 
                UIGraphicsBeginImageContext(pageSize)
                let context = UIGraphicsGetCurrentContext()!
                context.saveGState()
                context.translateBy(x: 0.0, y: pageSize.height)
                context.scaleBy(x: 1.0, y: -1.0)
                context.concatenate(page.getDrawingTransform(.mediaBox,
                                                             rect: page.getBoxRect(.mediaBox),
                                                             rotate: 0, preserveAspectRatio: true))
                context.drawPDFPage(page)
                context.restoreGState()
                if let image = UIGraphicsGetImageFromCurrentImageContext() {
                    if book == nil {book = Book()}
                    book?.append(image)
                }
                UIGraphicsEndImageContext()
            }
            return book
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

extension ComicManager {
    
    static func retreaveMetadata(for comics: [ComicPath], completion: @escaping (_ : [Metadata]) -> Void) {
        let coreDataQueue = DispatchQueue(label: "com.oakes.Pop-Comics.cdQueue")
        coreDataQueue.async {
            var metaData = [Metadata]()
            for comic in comics {
                if let content = metadataForFile(comic: comic) {
                    metaData.append(content)
                } else  if let content = createMetadata(for: comic){
                    metaData.append(content)
                }
            }
            do {
                try CDStack.sharedInstance().managedObjectContext.save()
            } catch {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                completion(metaData)
            }
        }
    }
    
    fileprivate static func metadataForFile(comic: ComicPath) -> Metadata? {
        guard let uuid = comic.UUID else {
            return nil
        }
        let context = CDStack.sharedInstance().managedObjectContext
        let predicate = NSPredicate(format: "uuid = %@", uuid)
        let fetchRequest = NSFetchRequest<Metadata>(entityName: "Metadata")
        fetchRequest.predicate = predicate
        do {
            let metadata = try context?.fetch(fetchRequest)
            return metadata?.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    fileprivate static func createMetadata(for comic: ComicPath) -> Metadata? {
        let images = self.openComic(at: comic.url.path)
        let cover = UIImagePNGRepresentation((images?.first ?? #imageLiteral(resourceName: "genaricComic")))
        let context = CDStack.sharedInstance().managedObjectContext
        let entityDiscription = NSEntityDescription.entity(forEntityName: "Metadata",
                                                           in: context!)
        let metadataObject = NSManagedObject(entity: entityDiscription!, insertInto: context) as? Metadata ?? Metadata(entity: entityDiscription!, insertInto: context)
        metadataObject.setValue(comic.UUID, forKey: "uuid")
        metadataObject.setValue(false, forKey: "read")
        metadataObject.setValue(cover, forKey: "coverImage")
        return metadataObject
    }
}
