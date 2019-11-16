//
//  FavInteractor.swift
//  Teremok-TV
//
//  Created by R9G on 14/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavBusinessLogic {
    func fetchFav()
    func unLikeVideo(idx: Int)
    func deleteLocalVideo(idx: Int)
}

protocol FavDataStore {
    var videoModels: [VideoModel] { get set }
    var savedVideos: [URL] { get set }
    var offlineVideos: [Fav.OfflineVideoModel] { get set }
    var hlsStreams: [Asset] { get set }
    func deleteLocalVideo(idx: Int)
}

class FavInteractor: FavBusinessLogic, FavDataStore {
    var videoModels: [VideoModel] = []
    var savedVideos: [URL] = []

    var offlineVideos: [Fav.OfflineVideoModel] = []

    var presenter: FavPresentationLogic?

    let service: FavProtocol = FavService()
    var actionService: ActionProtocol = ActionService()

    init() {
         NotificationCenter.default.addObserver(self, selector: #selector(self.fetchSaved), name: .FavBadge, object: nil)
     }
     deinit {
         NotificationCenter.default.removeObserver(self, name: .FavBadge, object: nil)
     }

    func fetchFav() {
        fetchSaved()
        fetchLike()
    }
    
    func fetchLike() {
        service.getFavorites { [weak self] (response) in
            switch response {
            case .success(let result):
                guard let models = result.favorite else {
                    self?.presenter?.present(errorString: "Пусто", completion: nil)
                    return
                }
                self?.videoModels = models
                self?.presenter?.presentFav(models)
            case .failure(let error):
                self?.presenter?.presentError(error: error, completion: nil)
            }
        }
    }

    var hlsStreams: [Asset] = []

    @objc func fetchSaved() {
        if let list = getList() {
            DispatchQueue.global().async {
                self.savedVideos = list.filter({$0.pathExtension == "mp4"}).sorted { $0.lastPathComponent < $1.lastPathComponent }
                let savedPics = list.filter({$0.pathExtension == "png"}).sorted { $0.lastPathComponent < $1.lastPathComponent }
                self.offlineVideos = []
                var ids: [Int] = []
                for videoUrl in self.savedVideos {
                    let id = videoUrl.deletingPathExtension().lastPathComponent
                    if let numIds = Int(id) {
                        ids.append(numIds)
                    }
                    let pngUrl = savedPics.filter({$0.deletingPathExtension().lastPathComponent == id}).first
                    let offlineVideoModel = Fav.OfflineVideoModel(id: id, videoUrl: videoUrl, image: .url(pngUrl))
                    self.offlineVideos.append(offlineVideoModel)
                }
                self.appendHLS()
                self.presenter?.presentSaved(models: self.offlineVideos)
                self.syncDownloads(ids: ids)
            }
        }
    }

    func appendHLS() {
        let fileManager = FileManager.default
        let hlsAsset = HLSAssets.fromDefaults()
        hlsStreams = hlsAsset.streams
        for (index, asset) in self.hlsStreams.enumerated() {
            guard let bookmark = asset.bookmark else { return }
            var bookmarkDataIsStale = false
            do {
                let location = try URL(resolvingBookmarkData: bookmark, bookmarkDataIsStale: &bookmarkDataIsStale)
                if bookmarkDataIsStale {
                    fatalError("Bookmark data is stale!")
                }
                guard fileManager.fileExists(atPath: location.path) else {
                    hlsStreams.remove(at: index)
                    hlsAsset.streams = hlsStreams
                    hlsAsset.saveToDefaults()
                    continue
                }
                offlineVideos.append(
                    Fav.OfflineVideoModel(id: asset.stream?.streamID.stringValue ?? "", videoUrl: location, image: .data(asset.stream?.art))
                )
            } catch {
                hlsStreams.remove(at: index)
                hlsAsset.streams = hlsStreams
                hlsAsset.saveToDefaults()
                continue
            }
        }
    }

    func unLikeVideo(idx: Int) {
        guard let id = videoModels[safe:idx]?.id else {
            return
        }
        actionService.toFav(with: id) { [weak self] (response) in
            switch response {
            case .success(_ ):
                self?.fetchLike()
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }

    func syncDownloads(ids: [Int]) {
        service.toSyncDownload(id: ids)
    }
    
    func getList() -> [URL]? {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print(fileURLs.debugDescription)
            return fileURLs
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return nil
    }

    func deleteLocalVideo(idx: Int) {
        if idx > (savedVideos.count - 1) {
            let stream = HLSAssets.fromDefaults()
            let assetIndex = stream.streams.firstIndex(of: hlsStreams[idx-(offlineVideos.count - 1)])!
            if let localFileLocation = stream.streams[assetIndex].url {
                try? FileManager.default.removeItem(at: localFileLocation)
            }
            stream.streams.remove(at: assetIndex)
            stream.saveToDefaults()

        } else if let video = offlineVideos[safe: idx] {
            removeModel(video)
        }
        fetchSaved()
    }
    
    func removeModel(_ video: Fav.OfflineVideoModel) {
        switch video.image {
            case .url(let url):
                deleteFrom(url: video.videoUrl)
                if let urlImage = url {
                    deleteFrom(url: urlImage)
                }
            case .data(_):
                break
        }
    }

    func deleteFrom(url: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: url)
        } catch {
            print("Error while delete files \(url): \(error.localizedDescription)")
        }
    }
}
