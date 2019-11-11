//
//  FavModels.swift
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

enum Fav {
    // MARK: Use cases
  
    struct Item {
        var imageUrl: URL?
    }
    
    struct OfflineVideoModel {
        var id: String
        var videoUrl: URL
        var imageUrl: URL?
    }
    
    enum Section: CaseIterable {
        case Favorite
        case Saved
        
        var name: String {
            switch self {
            case .Favorite:
                return " Любимое Видео"
            case .Saved:
                return " Сохраненное видео"
            }
        }
        var image: UIImage {
            switch self {
            case .Favorite:
                return #imageLiteral(resourceName: "icHeart")
            case .Saved:
                return #imageLiteral(resourceName: "icDown")
            }
        }
    }
}
