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
    
    typealias comicPath = (name: String, path: URL, isDirectory: Bool)
    
    func retreaveComicPaths() -> [comicPath] {
        let fileManager = FileManager.default
        do {
            let documentsDir = try fileManager.url(for: .documentDirectory,
                                               in: .userDomainMask,
                                               appropriateFor: nil,
                                               create: false)
            let contents = try fileManager.contentsOfDirectory(at: documentsDir,
                                                           includingPropertiesForKeys: [.isDirectoryKey, .isRegularFileKey],
                                                           options: .skipsHiddenFiles)
            return []
        } catch {
            print(error.localizedDescription)
            return [comicPath]()
        }
    }
}
