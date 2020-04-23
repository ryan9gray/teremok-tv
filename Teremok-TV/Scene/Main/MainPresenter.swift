//
//  MainPresenter.swift
//  Teremok-TV
//
//  Created by R9G on 22.08.2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainPresentationLogic: CommonPresentationLogic {
    func presentMainRazdels(_ models: [RazdelModel])
    func presentSeriesRazdel(indexPath: IndexPath, items: [RazdelItemResponse])
    func presentVideo(indexPath: IndexPath, items: [VideoModel])
}

class MainPresenter: MainPresentationLogic {
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    weak var viewController: MainDisplayLogic?
  
    
    // MARK: Do something
    
    func presentMainRazdels(_ models: [RazdelModel]) {
        let items = models.map { Main.RazdelItem(title: $0.name ?? "",
                                                 link: $0.animationUrl ?? "", countItems: $0.countItems ?? 0,
                                                 topVideos: $0.top?.map {Main.RazdelItemTop(poster: $0.poster ?? "",
                                                                                            name: $0.name ?? "")} ?? []) }
        viewController?.display(razdels: items)
    }
    
    func presentSeriesRazdel(indexPath: IndexPath, items: [RazdelItemResponse]){
        
        var serials: [RazdelVCModel.SerialItem] = []
        for item in items {
            let serial = RazdelVCModel.SerialItem(id: item.id ?? 0, name: item.name ?? "", imageUrl: item.poster ?? "", description: item.description ?? "")
            serials.append(serial)
        }
        
        viewController?.seriesDisplay(indexPath: indexPath, show: serials)
    }
    
    func presentVideo(indexPath: IndexPath, items: [VideoModel]){
        
        var serials: [Serial.Item] = []

        for item in items {
            guard let id = item.id else { return }
            let serial = Serial.Item(id: id, name: item.name ?? "", imageUrl: item.picture ?? "",description: item.description ?? "", isLikeMe: item.likedMe ?? false, isDownload: item.downloadMe ?? false, downloadLink: item.downloadLink)
            serials.append(serial)
        }
        viewController?.seriesDisplay(indexPath: indexPath, show: serials)
    }
}
