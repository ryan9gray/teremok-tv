//
//  ChildProfileDonePresenter.swift
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

protocol ChildProfileDonePresentationLogic: CommonPresentationLogic {
    func presentData(child: Child, title: String)
}

class ChildProfileDonePresenter: ChildProfileDonePresentationLogic {
    weak var viewController: ChildProfileDoneDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    // MARK: Do something
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    func presentData(child: Child, title: String){
        guard let age = child.birthdate?.ageString, let sex = child.sex?.kid else { return }
        
        let ageAndSex = age + ", " + sex
        self.viewController?.displayData(name: child.name ?? "", ageAndSex: ageAndSex, title: title, pic: child.pic)
    }
}