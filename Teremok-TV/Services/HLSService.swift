//
//  HLSService.swift
//  Teremok-TV
//
//  Created by Eugene Ivanov on 11.11.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import Foundation
import AVFoundation
import UIKit

fileprivate let backgroundIdentifier = "ru.xmedia.teremoktv.hlsBackground"
fileprivate let notificationIdentifier = "teremoktv"

class HLSDownloadService: NSObject, AVAssetDownloadDelegate {
    static let shared = HLSDownloadService()

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.done), name: .FavBadge, object: nil)
    }

    var isDownLoad = false

    lazy private var downloadSession: AVAssetDownloadURLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: backgroundIdentifier)
        return AVAssetDownloadURLSession(
            configuration: configuration,
            assetDownloadDelegate: self,
            delegateQueue: OperationQueue.main
        )
    }()

    var list: Set<Stream> = Set()

    private func addToList(video: Stream) {
        list.insert(video)
        guard !isDownLoad else { return }

        download(video)
    }

    private func removeFromList(_ video: Stream) {
        list.remove(video)
        isDownLoad = false
        guard let next = list.first else { return }

        download(next)
    }

    @objc func done(_ notification: Notification) {
        if let filename = notification.object as? String {
            print("\(filename) Notify!")
            if let video = self.list.lazy.filter({ $0.name == filename }).first {
                removeFromList(video)
            }
        }
    }
    
    private func download(_ video: Stream) {
        let asset = AVURLAsset(url: video.url)
        let downloadTask = downloadSession.makeAssetDownloadTask(
            asset: asset,
            assetTitle: video.name,
            assetArtworkData: video.art,
            options: nil
        )
        downloadTask?.resume()
    }

    func assetDownload(_ videoModel: VideoModel) {
    }

    func assetDownload(url: URL, name: String, art: Data?, id: Int) {
        let video: Stream = .init(url: url, name: name, art: art, id: id)
        addToList(video: video)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didFinishDownloadingTo location: URL) {
        let asset = assetDownloadTask.urlAsset
        guard let video = list.first(where: { $0.url == asset.url }) else { return }

        let streams = HLSAssets.fromDefaults()
        streams.streams.append(video)
        streams.saveToDefaults()
        NotificationCenter.default.post(name: .FavBadge, object: video.name, userInfo: ["Fav": 1])
        NotificationCenter.default.post(name: .UploadProgress, object: 1.0)
    }

    func urlSession(_ session: URLSession, assetDownloadTask: AVAssetDownloadTask, didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue], timeRangeExpectedToLoad: CMTimeRange) {
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange = value.timeRangeValue
            percentComplete += loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        print("\(percentComplete)")
        NotificationCenter.default.post(name: .UploadProgress, object: percentComplete)
    }

//    func restorePendingDownloads() {
//        // Grab all the pending tasks associated with the downloadSession
//        downloadSession.getAllTasks { tasksArray in
//            // For each task, restore the state in the app
//            for task in tasksArray {
//                guard let downloadTask = task as? AVAssetDownloadTask else { break }
//                // Restore asset, progress indicators, state, etc...
//                let asset = downloadTask.urlAsset
//            }
//        }
//    }
}

extension Notification.Name {
    /// Notification for when download progress has changed.
    static let AssetDownloadProgress = Notification.Name(rawValue: "AssetDownloadProgressNotification")

    /// Notification for when the download state of an Asset has changed.
    static let AssetDownloadStateChanged = Notification.Name(rawValue: "AssetDownloadStateChangedNotification")

    /// Notification for when AssetPersistenceManager has completely restored its state.
    static let AssetPersistenceManagerDidRestoreState = Notification.Name(rawValue: "AssetPersistenceManagerDidRestoreStateNotification")
}
