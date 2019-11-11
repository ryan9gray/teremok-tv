//
//  FavPresenter.swift
//  Teremok-TV
//
//  Created by R9G on 14/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavPresentationLogic: CommonPresentationLogic {
    func presentFav(_ models: [VideoModel])
    func presentSaved(models:[Fav.OfflineVideoModel])
}

class FavPresenter: FavPresentationLogic {
    weak var viewController: FavDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    
    func presentFav(_ models: [VideoModel]) {
        var fav: [Fav.Item] = []
        for item in models  {
            let serial = Fav.Item(imageUrl:  URL(string: item.picture ?? "")!)
            fav.append(serial)
        }
        viewController?.display(fav: fav)
    }

    func presentSaved(models:[Fav.OfflineVideoModel]) {
        var saved: [Fav.Item] = []
        models.forEach { model in
            let seria = Fav.Item(imageUrl:  model.imageUrl ?? URL(fileURLWithPath: ""))
            saved.append(seria)
            
        }
        DispatchQueue.main.async {
            self.viewController?.display(saved: saved)
        }
    }
}
