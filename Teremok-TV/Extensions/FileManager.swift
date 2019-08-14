//
//  FileManager.swift
//  gu
//
//  Created by Антонов Владислав Андреевич on 10.07.17.
//  Copyright © 2017 tt. All rights reserved.
//

import UIKit

extension FileManager {
    
    func fileExistsAtURL(_ url: URL) -> Bool {
        return fileExists(atPath: url.path)
    }
    
    func removeItemIfExistsAtURL(_ url: URL) {
        do {
            if fileExistsAtURL(url) {
                try removeItem(at: url)
            }
        } catch let error {
            print(String(describing: error))
        }
    }
    
    func createDirectoryForFileUrl(_ url: URL) {
        do {
            let directoryUrl = url.deletingLastPathComponent()
            if !fileExistsAtURL(directoryUrl) {
                try createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            }
        } catch {
        }
    }
}
