//
//  SerialPresenter.swift
//  Teremok-TV
//
//  Created by R9G on 06/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SerialPresentationLogic: CommonPresentationLogic {
    func present(items: [VideoModel])
}

class SerialPresenter: SerialPresentationLogic {
    weak var viewController: SerialDisplayLogic?
  
    var displayModule: CommonDisplayLogic? {
        return viewController
    }

    // MARK: Do something
    func present(items: [VideoModel]){
        
        var serials: [Serial.Item] = []

        for item in items {
            let serial = Serial.Item(name: item.name ?? "", imageUrl: item.picture ?? "",description: item.description ?? "", isLikeMe: item.likedMe ?? false, isDownload: item.downloadMe ?? false)
            serials.append(serial)
        }        
        viewController?.displaySerials(serials)
    }
}
