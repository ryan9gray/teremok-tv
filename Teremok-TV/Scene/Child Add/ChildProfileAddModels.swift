//
//  ChildProfileAddModels.swift
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

enum ChildProfileAdd {
    enum Screen {
        case Modify(Child?)
        case Registrate
        case Add
        
        var doneTitle: String {
            switch self {
            case .Add:
                return "Отличная работа, \nпрофиль добавлен!"
            case .Modify(let child):
                return "Профиль \(child?.name ?? "Ребенка") отредактирован"
            case .Registrate:
                return "Отличная работа, \nпрофиль создан!"
            }
        }
    }
}
