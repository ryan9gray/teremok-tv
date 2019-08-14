//
//  ChildProfileAddPresenter.swift
//  Teremok-TV
//
//  Created by R9G on 30/08/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChildProfileAddPresentationLogic: CommonPresentationLogic {
    func present(date: Date)
    func presentFinish()
    func presentChild(_ child: Child)
}

class ChildProfileAddPresenter: ChildProfileAddPresentationLogic {
    weak var viewController: ChildProfileAddDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    // MARK: Do something
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    func present(date: Date) {
        viewController?.display(birthday: formatter.string(from: date))
    }
    func presentFinish(){
        viewController?.displayFinish()
    }
    func presentChild(_ child: Child){
        viewController?.displayChild(child)
        if let date = child.birthdate {
            present(date: date)
        }
    }

    
}
