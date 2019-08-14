//
//  AnimalPackDownloader.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 09/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Foundation

class AnimalPackDownloader {

    var isFirst = true

    private func createAnimalPackFolder(pack: String) {
        let fileManager = FileManager.default
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        var path = documentsURL.appendingPathComponent("Animals")
        path.appendPathComponent(pack)

        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }

    func downloadPack(item: AnimalsGame.PackAnimal, pack: String, complition: @escaping (Bool) -> Void){
        guard let soundLink =  URL(string: item.sound), let imageLink = URL(string: item.image)
        else {
            complition(false)
            return
        }
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        let local: AnimalsGame.AnimalLocal = AnimalsGame.AnimalLocal()
        local.name = item.name
        let soundName = item.name + "." + soundLink.pathExtension
        loadFileAsync(url: soundLink, name: soundName, pack: pack) { result in
            if result != nil {
                local.sound = soundName
                dispatchGroup.leave()
            } else {
                complition(false)
            }
        }

        dispatchGroup.enter()
        let imageName = item.name + "." + imageLink.pathExtension
        loadFileAsync(url: imageLink, name: imageName, pack: pack) { result in
            if (result != nil) {
                local.image = imageName
                dispatchGroup.leave()
            } else {
                complition(false)
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.locals.append(local)
            complition(true)
        }
    }

    var locals: [AnimalsGame.AnimalLocal] = []

    private func loadFileAsync(url: URL, name: String, pack: String, completion: @escaping (URL?) -> Void) {
        createAnimalPackFolder(pack: pack)

        // create your document folder url
        var destination = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        // your destination file url
        destination.appendPathComponent("Animals")
        destination.appendPathComponent(pack)
        destination.appendPathComponent(name)

        if FileManager().fileExists(atPath: destination.path) {
            print("The file already exists at path, deleting and replacing with latest")
            print(destination.path)
            if FileManager().isDeletableFile(atPath: destination.path) {
                do{
                    try FileManager().removeItem(at: destination)
                    print("previous file deleted")
                    self.saveFile(url: url, destination: destination) { (complete) in
                        if complete {
                            completion(destination)
                        } else {
                            completion(nil)
                        }
                    }
                }catch{
                    print("current file could not be deleted")
                }
            }
            // download the data from your url
        }else{
            self.saveFile(url: url, destination: destination) { (complete) in
                if complete{
                    completion(destination)
                } else {
                    completion(nil)
                }
            }
        }
    }

    private func saveFile(url: URL, destination: URL, completion: @escaping (Bool) -> Void){
        URLSession.shared.downloadTask(with: url, completionHandler: { (location, response, error) in
            // after downloading your data you need to save it to your destination url
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let location = location, error == nil
                else { print("error with the url response"); completion(false); return}
            do {
                try FileManager.default.moveItem(at: location, to: destination)
                print("new file saved")
                completion(true)
            } catch {
                print("file could not be saved: \(error)")
                completion(false)
            }
        }).resume()
    }
}

