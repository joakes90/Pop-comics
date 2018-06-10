//
//  FileController.swift
//  Pop Comics
//
//  Created by Justin Oakes on 12/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import Foundation
import UIKit

class FileController {
    
    static let shared = FileController()
    private var paths: [ComicPath] = [ComicPath]()
    
    func comicPathsBySection() -> [ComicSecton] {
        let comicPaths = retreaveComicPaths()
        var sections = [ComicSecton]()
        
        for path in comicPaths {
            let firstLetter = String(path.name.first ?? "A").uppercased()
            if let index = sections.index(where: { $0.letter == firstLetter}) {
                sections[index].comicPaths.append(path)
            } else {
                let section = ComicSecton(letter: firstLetter, comicPaths: [path])
                sections.append(section)
            }
        }
        return sections.sorted(by: { $0.letter < $1.letter })
    }
    
    func retreaveComicPaths(forceUpdate: Bool = false) -> [ComicPath] {
        if paths.count <= 0 || forceUpdate {
            let fileManager = FileManager.default
            do {
                let documentsDir = try fileManager.url(for: .documentDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: nil,
                                                       create: false)
                let contents = try fileManager.contentsOfDirectory(at: documentsDir,
                                                                   includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey],
                                                                   options: .skipsHiddenFiles)
                var comicPaths = [ComicPath]()
                contents.forEach { (url) in
                    let isDirectory = fileIsDirectory(url: url)
                    if isDirectory || fileIsComic(url: url) {
                        comicPaths.append(ComicPath(name: (url.lastPathComponent as NSString).deletingPathExtension,
                                                    url: url,
                                                    isDirectory: isDirectory,
                                                    UUID: UUIDforFile(file: url)))
                    }
                }
                paths = comicPaths
                return comicPaths.sorted(by: { $0.name < $1.name })
            } catch {
                print(error.localizedDescription)
                paths = [ComicPath]()
                return [ComicPath]()
            }
        }
        return paths.sorted(by: { $0.name < $1.name })
    }
    
    func UUIDforFile(file: URL) -> String? {
        let fileManager = FileManager.default
        do {
            let attributes = try fileManager.attributesOfItem(atPath: file.path)
            return String(attributes[.systemFileNumber] as? Int ?? -1)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func comicsIn(url: URL, completion: (_ : ([ComicPath]) -> Void)) {
        let comicsQueue = DispatchQueue(label: "com.oakes.Pop-Comics.comicQueue")
        comicsQueue.async {
            let fileManager = FileManager.default
            do {
                let dirContents = try fileManager.contentsOfDirectory(at: url,
                                                                      includingPropertiesForKeys: [.isRegularFileKey],
                                                                      options: [.skipsHiddenFiles, .skipsPackageDescendants, .skipsSubdirectoryDescendants])
                var comicPaths = [ComicPath]()
                for file in dirContents {
                    if self.fileIsComic(url: file) {
                        let comicPath = ComicPath(name: (file.lastPathComponent as NSString).deletingPathExtension,
                                                  url: file,
                                                  isDirectory: false,
                                                  UUID: self.UUIDforFile(file: file))
                        comicPaths.append(comicPath)
                    }
                }
                DispatchQueue.main.async {
                    completion(comicPaths)
                }
            } catch {
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    completion([ComicPath]())
                }
            }
        }
    }
    
    func cleanTmp() {
        let cleanDirQueue = DispatchQueue(label: "com.oakes.Pop-Comics.clean")
        let fileManager = FileManager.default
        let tmpDir = fileManager.temporaryDirectory
        do {
            let files = try fileManager.contentsOfDirectory(at: tmpDir,
                                                        includingPropertiesForKeys: nil,
                                                        options: .skipsHiddenFiles)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func comicPathAt(url: URL) -> ComicPath {
        return ComicPath(name: (url.lastPathComponent as NSString).deletingPathExtension,
                                  url: url,
                                  isDirectory: false,
                                  UUID: UUIDforFile(file: url))
        
    }
    fileprivate func fileIsDirectory(url: URL) -> Bool {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
        
    }
    
    fileprivate func fileIsComic(url: URL) -> Bool {
            let fileExtension = url.pathExtension
        if extensions(rawValue: fileExtension) != nil {
            return true
        }
        return false
    }
    
    fileprivate func coverImage(for url: URL) -> UIImage {
        if extensions(rawValue: url.pathExtension) != nil {
            guard let images = ComicManager.openComic(at: url.path) else {
                return #imageLiteral(resourceName: "genaricComic")
            }
            return images.first ?? #imageLiteral(resourceName: "genaricComic")
        }
        return #imageLiteral(resourceName: "genaricComic")
    }
}

struct ComicPath {
    let name: String
    let url: URL
    let isDirectory: Bool
    let UUID: String?
}

struct ComicSecton {
    let letter: String
    var comicPaths: [ComicPath]
}
