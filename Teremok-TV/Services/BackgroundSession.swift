//
//  BackgroundSession.swift
//  Teremok-TV
//
//  Created by R9G on 22/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import UserNotifications

fileprivate let backgroundIdentifier = "ru.xmedia.teremoktv"
fileprivate let notificationIdentifier = "teremoktv"
    
final class BackgroundSession {
    static let shared = BackgroundSession()
    private let manager: SessionManager

    /// Save background completion handler, supplied by app delegate
    
    func saveBackgroundCompletionHandler(_ backgroundCompletionHandler: @escaping () -> Void) {
        manager.backgroundCompletionHandler = backgroundCompletionHandler
    }

    private init() {
        let configuration = URLSessionConfiguration.background(withIdentifier: backgroundIdentifier)
        manager = SessionManager(configuration: configuration)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.done), name: .MusicBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.done), name: .FavBadge, object: nil)

        manager.delegate.downloadTaskDidFinishDownloadingToURL = { [weak self] _, task, location in
            guard let self = self else { return }

            do {
                guard
                    let video = self.list.filter({ $0.fileName == task.originalRequest!.url!.lastPathComponent }).first
                else { return }

                var destination = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                if video.fileName.split(separator: ".").last == "m4a" {
                    self.createMusicFolder()
                    destination.appendPathComponent("Music")
                }

                destination.appendPathComponent(video.id)
                try FileManager.default.copyItem(at: location, to: destination)
            } catch {
                print("\(error)")
            }
        }
        
        /// specify what to do when background session finishes; i.e. make sure to call saved completion handler
        /// if you don't implement this, it will call the saved `backgroundCompletionHandler` for you
        manager.delegate.sessionDidFinishEventsForBackgroundURLSession = { [weak self] _ in
            self?.manager.backgroundCompletionHandler?()
            self?.manager.backgroundCompletionHandler = nil
            
            // if you want, tell the user that the downloads are done

            let content = UNMutableNotificationContent()
            content.title = "Скачено"
            content.body = "Ура!"
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let notification = UNNotificationRequest(identifier: notificationIdentifier, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(notification)            
        }

        manager.delegate.taskDidComplete = { _, task, error in
            guard let filename = task.originalRequest?.url?.lastPathComponent else { return }
            if let error = error {
                print("\(filename) error: \(error)")
            } else {
                print("\(filename) done!")

            }
            if filename.split(separator: ".").last == "m4a" {
                NotificationCenter.default.post(name: .MusicBadge, object: filename, userInfo: nil)
            } else {
                NotificationCenter.default.post(name: .FavBadge, object: filename, userInfo: ["Fav": 1])
            }
            NotificationCenter.default.post(name: .UploadProgress, object: 1.0)

            /// I might want to post some event to `NotificationCenter`
            /// so app UI can be updated, if it's in foreground
        }
    }

    @objc func done(_ notification: Notification) {
        if let filename = notification.object as? String {
            print("\(filename) Notify!")
            if let video = self.list.lazy.filter({ $0.fileName == filename }).first {
                self.removeFromList(video)
            }
        }
    }

    var list: Set<Video> = Set()

    struct Video: Hashable {
        let url: URL
        let fileName: String
        let id: String
    }

    var isDownLoad = false

    private func removeFromList(_ video: Video) {
        self.list.remove(video)
        isDownLoad = false
        guard let next = list.first else { return }

        download(next)
    }

    private func addToList(_ video: Video) {
        list.insert(video)
        if !isDownLoad {
            self.download(video)
        }
    }

    private func download(_ video: Video) {
        self.isDownLoad = true
        let utilityQueue = DispatchQueue.global(qos: .utility)
        manager.download(video.url).downloadProgress(queue: utilityQueue) { progress in
            NotificationCenter.default.post(name: .UploadProgress, object: progress.fractionCompleted)
            print("Download Progress: \(progress.fractionCompleted)")
        }
    }

    func download(_ url: URL, name: String) {
        let id = name + "." + url.pathExtension
        let fileMame = url.lastPathComponent
        addToList(Video(url: url, fileName: fileMame, id: id))
    }

    private func createMusicFolder() {
        let fileManager = FileManager.default
        let documentsURL =  fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let path = documentsURL.appendingPathComponent("Music")

        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }
}

