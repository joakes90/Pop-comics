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
                    let comicPath = ComicPath(name: url.lastPathComponent,
                                              path: url,
                                              isDirectory: fileIsDirectory(url: url))
                    comicPaths.append(comicPath)
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
    
    fileprivate func fileIsDirectory(url: URL) -> Bool {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return isDirectory.boolValue
        
    }
}

struct ComicPath {
    let name: String
    let path: URL
    let isDirectory: Bool
}
