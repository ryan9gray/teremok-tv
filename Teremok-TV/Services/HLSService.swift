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

    func assetDownload(url: URL, name: String, art: Data?, id: Int) {

        let video: Stream = .init(playListURL: url, name: name, art: art, id: id)
        addToList(video)
    }

    private func addToList(_ stream: Stream) {
        list.insert(stream)
        guard !isDownLoad else { return }

        download(stream)
    }

    private func removeFromList(_ stream: Stream) {
        list.remove(stream)
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
    
    private func download(_ stream: Stream) {
        guard let url = stream.playListURL else { return }
        let asset = AVURLAsset(url: url)
        guard let task =
            downloadSession.aggregateAssetDownloadTask(
                with: asset,
                mediaSelections: [asset.preferredMediaSelection],
                assetTitle: stream.name ?? "",
                assetArtworkData: stream.art,
                options: [AVAssetDownloadTaskMinimumRequiredMediaBitrateKey: 265_000]
            )
        else { return }
        task.taskDescription = stream.name
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                       didCompleteFor mediaSelection: AVMediaSelection
    ) {
        //let asset = aggregateAssetDownloadTask.urlAsset
        //guard let video = list.first(where: { $0.playListURL == asset.url }) else { return }

        NotificationCenter.default.post(name: .UploadProgress, object: 1.0)
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                    didLoad timeRange: CMTimeRange, totalTimeRangesLoaded loadedTimeRanges: [NSValue],
                    timeRangeExpectedToLoad: CMTimeRange, for mediaSelection: AVMediaSelection
    ) {
        var percentComplete = 0.0
        for value in loadedTimeRanges {
            let loadedTimeRange: CMTimeRange = value.timeRangeValue
            percentComplete +=
                loadedTimeRange.duration.seconds / timeRangeExpectedToLoad.duration.seconds
        }
        print("\(percentComplete)")
        NotificationCenter.default.post(name: .UploadProgress, object: percentComplete)
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                    willDownloadTo location: URL
    ) {
        guard let stream = list.first(where: { $0.playListURL == aggregateAssetDownloadTask.urlAsset.url }) else { return }

        let asset: Asset = .init(url: location, stream: stream)
        let streams = HLSAssets.fromDefaults()
        streams.streams.append(asset)
        streams.saveToDefaults()
        NotificationCenter.default.post(name: .FavBadge, object: stream.name, userInfo: ["Fav": 1])
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
