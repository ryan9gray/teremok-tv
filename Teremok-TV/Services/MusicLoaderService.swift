//
//  MusicLoaderService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 14/04/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import Foundation

struct MusicLoaderService {

    func getList() -> [URL] {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Music") else { return [] }
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs.debugDescription)
            return fileURLs.filter({$0.pathExtension == "m4a"}).sorted { $0.lastPathComponent < $1.lastPathComponent }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return []
    }

    func createFolder() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentsDirectory: AnyObject = paths[0] as AnyObject
        let dataPath = documentsDirectory.appendingPathComponent("Music")!

        do {
            try FileManager.default.createDirectory(atPath: dataPath.absoluteString, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
}
