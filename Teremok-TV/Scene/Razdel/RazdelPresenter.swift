//
//  RazdelPresenter.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol RazdelPresentationLogic: CommonPresentationLogic {
    func present(items: [RazdelItemResponse])
}

class RazdelPresenter: RazdelPresentationLogic {
    weak var viewController: RazdelDisplayLogic?
  
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    
    func present(items: [RazdelItemResponse]){
        
        var serials: [RazdelVCModel.SerialItem] = []
        for item in items {
            let serial = RazdelVCModel.SerialItem(name: item.name ?? "", imageUrl: item.poster ?? "", description: item.description ?? "")
            serials.append(serial)
        }
        
        viewController?.displaySerials(serials)
    }
    
}