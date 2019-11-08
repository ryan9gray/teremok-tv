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

fileprivate let backgroundIdentifier = "ru.xmedia.teremoktv.background"
fileprivate let notificationIdentifier = "teremoktv"
    
final class BackgroundSession: NSObject, URLSessionDownloadDelegate {
    static let shared = BackgroundSession()

    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.done), name: .MusicBadge, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.done), name: .FavBadge, object: nil)
    }

    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    func localFilePath(for url: URL) -> URL {
      return documentsPath.appendingPathComponent(url.lastPathComponent)
    }
    lazy private var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()

    private func download(_ video: Video) {
        downloadAlert = configureAlert(with: "Не выключайте приложение пока идет скачивание")
        isDownLoad = true
        let task = downloadsSession.downloadTask(with: video.url)
        task.resume()
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
    var isDownLoad = false
    struct Video: Hashable {
        let url: URL
        let fileName: String
        let id: String
    }

    private func removeFromList(_ video: Video) {
        self.list.remove(video)
        isDownLoad = false
        guard let next = list.first else { return }

        download(next)
    }

    private func addToList(_ video: Video) {
        list.insert(video)
        if !isDownLoad {
            download(video)
        }
    }

    func download(_ url: URL, name: String) {
        let id = name + "." + url.pathExtension
        let fileMame = url.lastPathComponent
        addToList(Video(url: url, fileName: fileMame, id: id))
    }

    private func createMusicFolder() {
        let path = documentsPath.appendingPathComponent("Music")
        do {
            try FileManager.default.createDirectory(atPath: path.path, withIntermediateDirectories: false, attributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription);
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard
            let sourceURL = downloadTask.originalRequest?.url,
            let video = self.list.filter({ $0.fileName == sourceURL.lastPathComponent }).first
        else { return }

        var destination = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        if video.fileName.split(separator: ".").last == "m4a" {
           createMusicFolder()
           destination.appendPathComponent("Music")
        }
        destination.appendPathComponent(video.id)

        print(destination)
        let fileManager = FileManager.default
        try? fileManager.removeItem(at: destination)
        do {
            try fileManager.moveItem(at: location, to: destination)
            isDownLoad = false
        } catch let error {
          print("Could not copy file to disk: \(error.localizedDescription)")
        }

        DispatchQueue.main.async {
            self.downloadAlert?.dismiss(animated: true) {
                let filename = sourceURL.lastPathComponent
                if filename.split(separator: ".").last == "m4a" {
                    NotificationCenter.default.post(name: .MusicBadge, object: filename, userInfo: nil)
                } else {
                    NotificationCenter.default.post(name: .FavBadge, object: filename, userInfo: ["Fav": 1])
                }
                NotificationCenter.default.post(name: .UploadProgress, object: 1.0)
            }
        }
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        //guard let url = downloadTask.originalRequest?.url else { return }
        //let totalSize = ByteCountFormatter.string(fromByteCount: totalBytesExpectedToWrite, countStyle: .file)

        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        NotificationCenter.default.post(name: .UploadProgress, object: progress)
        if progress == 1 {

        }
        print("\(progress)")
    }

    class func load(url: URL, to localUrl: URL, completion: @escaping () -> ()) {
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let request = try! URLRequest(url: url, method: .get)

        let task = session.downloadTask(with: request) { (tempLocalUrl, response, error) in
            if let tempLocalUrl = tempLocalUrl, error == nil {
                // Success
                if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    print("Success: \(statusCode)")
                }

                do {
                    try FileManager.default.moveItem(at: tempLocalUrl, to: localUrl)
                    completion()
                } catch (let writeError) {
                    print("error writing file \(localUrl) : \(writeError)")
                }

            } else {
                print("Failure: %@", error?.localizedDescription ?? "");
            }
        }
        task.resume()
    }

    private weak var downloadAlert: UIAlertController?
    private func configureAlert(with title: String, message: String = "") -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Закрыть", style: .default, handler: nil)
        alertController.addAction(okAction)
        alertController.applyStyle()
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        return alertController
    }
}

extension BackgroundSession: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
      DispatchQueue.main.async {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
          let completionHandler = appDelegate.backgroundSessionCompletionHandler {
          appDelegate.backgroundSessionCompletionHandler = nil
          completionHandler()
        }
      }
    }
}

