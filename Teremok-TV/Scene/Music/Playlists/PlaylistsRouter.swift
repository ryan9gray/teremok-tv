//
//  PlaylistsRouter.swift
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

@objc protocol PlaylistsRoutingLogic {
    func playTrack(track: Int)
}

protocol PlaylistsDataPassing {
    var dataStore: PlaylistsDataStore? { get }
}

class PlaylistsRouter: NSObject, PlaylistsRoutingLogic, PlaylistsDataPassing, CommonRoutingLogic {
    var modalControllersQueue = Queue<UIViewController>()

    weak var viewController: PlaylistsViewController?
    var dataStore: PlaylistsDataStore?
    var isNew = true

    func playTrack(track: Int) {
        guard Profile.isAuthorized else {
            viewController?.presentCloud(title: "", subtitle: Main.Messages.auth, button: "Зарегистрироваться") { [weak self] in
                self?.viewController?.master?.openAutorization()
            }
            return
        }

        guard Profile.current?.premiumMusic ?? false else {
            viewController?.present(errorString: Main.Messages.accessMusic, completion: nil)
            return
        }
        guard let response = dataStore?.mainResponse else { return }
        viewController?.master?.play(type: .online(idx: track, playlist: response), isNew: isNew)
        isNew = false
    }
}
