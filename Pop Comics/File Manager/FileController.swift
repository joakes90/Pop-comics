//
//  FileController.swift
//  Pop Comics
//
//  Created by Justin Oakes on 12/5/18.
//  Copyright © 2018 Oklasoft LLC. All rights reserved.
//

import Foundation

class FileController {
    
    static let shared = FileController()
    
    private var paths: [ComicPath] = [ComicPath]()
    
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
                return comicPaths
            } catch {
                print(error.localizedDescription)
                paths = [ComicPath]()
                return [ComicPath]()
            }
        }
        return paths
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
    
}

struct ComicPath {
    let name: String
    let url: URL
    let isDirectory: Bool
    let UUID: String?
}
