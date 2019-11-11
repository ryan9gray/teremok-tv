//
//  VideoDownloadService.swift
//  Teremok-TV
//
//  Created by R9G on 27/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//
import Foundation

protocol VideoServiceProtocol {
    func downloadVideo(item: VideoModel)
    func addToFav(id: Int, complition: ((Bool) -> Void)?)
    func hlsDownload(url: URL, name: String, art: Data?, id: Int)
    var imageLoader: ImageLoader! { get set }
}

class VideoService: VideoServiceProtocol {
    var actionService: ActionProtocol = ActionService()
    var imageLoader: ImageLoader!

    func hlsDownload(url: URL, name: String, art: Data?, id: Int) {

        HLSDownloadService.shared.assetDownload(url: url, name: name, art: art, id: id)
    }

    func addToFav(id: Int, complition: ((Bool) -> Void)?) {
        actionService.toFav(with: id) { (response) in
            switch response {
            case .success(_ ):
                    complition?(true)
            case .failure(let error):
                print("\(error.localizedDescription)")
                complition?(false)
            }
        }
    }

    func downloadVideo(item: VideoModel){
        guard let id = item.id else { return }

        localDownload(item: item)
        actionDownload(id: id)
    }

    private func actionDownload(id: Int) {
        actionService.toDownload(with: id) { (response) in
             switch response {
             case .success(let action):
                print("Download action added: \(action.action == .added)")
             case .failure(let error):
                 print("\(error.localizedDescription)")
             }
         }
    }

    private func localDownload(item: VideoModel) {
        guard let str = item.downloadLink, !str.isEmpty, let link =  URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), let id = item.id, BackgroundSession.shared.list.count < 5  else {
            return
        }

        if let imageLink = item.picture, let downloadURL = URL(string: imageLink) {
            imageLoader.downloadFrom(url: downloadURL, name: id.stringValue)
        }
        BackgroundSession.shared.download(link, name: id.stringValue)
    }
}
