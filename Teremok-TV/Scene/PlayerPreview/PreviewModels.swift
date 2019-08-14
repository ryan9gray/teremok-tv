//
//  PreviewModels.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum Preview {
    // MARK: Use cases
  
    struct StreamItem {
        var link: String = ""
        var quality: String = ""
    }

    enum ItemType {
        case online(id: Int)
        case offline(idx: Int, models: [Fav.OfflineVideoModel])
    }
}
