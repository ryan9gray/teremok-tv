//
//  ColorsMasterPresenter.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ColorsMasterPresentationLogic: CommonPresentationLogic {
    
}

class ColorsMasterPresenter: ColorsMasterPresentationLogic {
    weak var viewController: ColorsMasterDisplayLogic?
    var displayModule: CommonDisplayLogic? {
        return viewController
    }
    // MARK: Do something

}
