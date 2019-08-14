//
//  TTPushActionType.swift
//  gu
//
//  Created by Sergey Starukhin on 10.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation

enum TTPushActionType {
    
    enum ChargeType: String {
        case current = "1"
        case debt = "2"
    }
    
    case unknown

    case web(link: URL)

    case pcs(UUID)

    case achieve
    case newVideo(id: Int)

    // MARK: - End local push actions
}
