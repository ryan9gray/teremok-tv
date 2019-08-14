//
//  VideoDownloadService.swift
//  Teremok-TV
//
//  Created by R9G on 27/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//
import Foundation

protocol VideoServiceProtocol {
    func downloadVideo(item: VideoModel, complition: ((Bool) -> Void)?)
    func addToFav(id: Int, complition: ((Bool) -> Void)?)
}

class VideoService: VideoServiceProtocol {
    var actionService: ActionProtocol = ActionService()
    var imageLoader = ImageLoader()

    func downloadVideo(item: VideoModel, complition: ((Bool) -> Void)?){
        
        guard let str = item.downloadLink, !str.isEmpty, let link =  URL(string: str.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!),let id = item.id, BackgroundSession.shared.list.count < 5  else {
            //complition?(false)
            return
        }

        if let imageLink = item.picture, let downloadURL = URL(string: imageLink) {
            imageLoader.downloadFrom(url: downloadURL, name: id.stringValue)
        }
        BackgroundSession.shared.download(link, name: id.stringValue)

        actionService.toDownload(with: id) { (response) in
            switch response {
            case .success(let action):
                let added = action.action == .added
                complition?(added)
            case .failure(let error):
                print("\(error.localizedDescription)")
                complition?(false)
            }
        }
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
}
