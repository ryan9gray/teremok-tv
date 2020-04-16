//
//  SearchInteractor.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SearchBusinessLogic {
    var hasMore : Bool { get }
    func fetchSearchTags()
    func selectTag(idx: Int)
}

protocol SearchDataStore {
    
}

class SearchInteractor: SearchBusinessLogic, SearchDataStore {
    var presenter: SearchPresentationLogic?
    
    let service: SearchProtocol = SearchService()
    
    var nextShift: Int?
    let countSerials = 10
    var hasMore : Bool = true
    var searchItems: [SearchItemResponse] = []
    
    func fetchSearchTags(){
        
        guard hasMore  else {
            return
        }
        service.getSearch(itemsOnPage: countSerials, shiftItem: nextShift ?? 0) { [weak self] (result) in
            switch result {
            case .success(let response):
                self?.response(model: response)
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
    }

    func response(model: SearchResponse){
        guard let items = model.items else { return }
        self.nextShift = model.startItemIdInNextPage
        self.hasMore = items.count > 0
        self.searchItems.append(contentsOf: items)
        
        self.presenter?.presentTags(items: searchItems)
    }
    
    func selectTag(idx: Int){
        
        guard let id = searchItems[safe: idx]?.seriesId else {
            return
        }
        //TO DO: поменять модель, чтобы получать имя персонажа Пузаков
        self.presenter?.presentSerial(id: id)
    }
    
    // MARK: Do something

}
