//
//  AlbumRouter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 17/03/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol AlbumRoutingLogic {
    func navigateToAlbum(number: Int)
    func navigateToDownload()
}

protocol AlbumDataPassing {
    var dataStore: AlbumDataStore? { get }
}

class AlbumRouter: NSObject, AlbumRoutingLogic, AlbumDataPassing, CommonRoutingLogic {
    weak var viewController: AlbumViewController?
    var dataStore: AlbumDataStore?
    var modalControllersQueue = Queue<UIViewController>()

    func navigateToAlbum(number: Int){
        let playlist = PlaylistsViewController.instantiate(fromStoryboard: .music)
        guard var dataStore = playlist.router?.dataStore else { return }
        guard let item = viewController?.router?.dataStore?.albums[safe: number] else {
            return
        }
        dataStore.albumId = item.id
        viewController?.masterRouter?.presentNextChild(viewController: playlist)
    }

    func navigateToDownload() {
        let playlist = OfflinePlaylistViewController.instantiate(fromStoryboard: .music)
        viewController?.masterRouter?.presentNextChild(viewController: playlist)
    }
}
