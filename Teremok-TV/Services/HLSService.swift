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
    var list: Set<Stream> = Set()

    lazy private var downloadSession: AVAssetDownloadURLSession = {
        let configuration = URLSessionConfiguration.background(withIdentifier: backgroundIdentifier)
        return AVAssetDownloadURLSession(
            configuration: configuration,
            assetDownloadDelegate: self,
            delegateQueue: OperationQueue.main
        )
    }()

    func assetDownload(url: URL, name: String, art: Data?, id: Int) {
        //let exumple = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/img_bipbop_adv_example_ts/master.m3u8")!
        print("\(art == nil)")
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
        task.resume()
    }

    func urlSession(_ session: URLSession, aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                       didCompleteFor mediaSelection: AVMediaSelection
    ) {
        guard let video = list.first(where: { $0.playListURL == aggregateAssetDownloadTask.urlAsset.url }) else { return }
        aggregateAssetDownloadTask.taskDescription = video.name
        //aggregateAssetDownloadTask.resume()
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
        print("\(location)")
        NotificationCenter.default.post(name: .FavBadge, object: stream.name, userInfo: ["Fav": 1])
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard let task = task as? AVAggregateAssetDownloadTask else { return }
        if let error = error as NSError? {
            switch (error.domain, error.code) {
            case (NSURLErrorDomain, NSURLErrorCancelled):
                print("\(error)")
                return
                let assets = HLSAssets.fromDefaults()
                guard
                    let video = list.first(where: { $0.playListURL == task.urlAsset.url }),
                    let asset = assets.streams.first(where: { $0.url == video.playListURL }),
                    let assetIndex = assets.streams.firstIndex(of: asset),
                    let localFileLocation = assets.streams[assetIndex].url
                else { return }

                do {
                    try FileManager.default.removeItem(at: localFileLocation)
                    assets.streams.remove(at: assetIndex)
                    assets.saveToDefaults()
                } catch {
                    print("An error occured trying to delete the contents on disk for : \(error)")
                }

            case (NSURLErrorDomain, NSURLErrorUnknown):
                fatalError("Downloading HLS streams is not supported in the simulator.")

            default:
                fatalError("An unexpected error occured \(error.domain)")
            }
        }
    }
}

extension Notification.Name {
    /// Notification for when download progress has changed.
    static let AssetDownloadProgress = Notification.Name(rawValue: "AssetDownloadProgressNotification")

    /// Notification for when the download state of an Asset has changed.
    static let AssetDownloadStateChanged = Notification.Name(rawValue: "AssetDownloadStateChangedNotification")

    /// Notification for when AssetPersistenceManager has completely restored its state.
    static let AssetPersistenceManagerDidRestoreState = Notification.Name(rawValue: "AssetPersistenceManagerDidRestoreStateNotification")
}
