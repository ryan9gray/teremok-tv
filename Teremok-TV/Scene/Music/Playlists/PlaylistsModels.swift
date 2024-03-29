//
//  PlaylistsModels.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 17/03/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

enum Playlist {  
    struct Item {
        let imageUrl: String
        let albumTitle: String
        let tracks: [Track]
    }

    struct Track {
        let title: String
        let subtitle: String
    }
}
