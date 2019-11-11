//
//  VideoItemModel.swift
//  Teremok-TV
//
//  Created by R9G on 05/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper


final class VideoItemModel: Mappable {
    
    var videoItem: VideoModel?
    
    var premium: Bool = false
    
    var copyrighter: CopyrighterResponse?
    var recommendations: [VideoModel]?
    var stream: String?
    var nextItem: Int?

    // Mappable
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        videoItem       <- map["videoItem"]
        premium     <- map["premium"]
        copyrighter     <- map["copyrighter"]
        recommendations     <- map["recommendations"]
        stream     <- map["stream"]
        nextItem   <- map["nextItem"]
    }
}


final class VideoModel: Mappable {
    var id: Int?
    var name: String?
    var description: String?
    var picture: String?
    var views: Int?
    var likes: Int?
    var duration: Int?
    var series: SeriesResponse?
    var downloadLink: String?

    var likedMe: Bool?
    var viewedMe: Bool?
    var downloadMe: Bool?

    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        description     <- map["description"]
        picture     <- map["picture"]
        views     <- map["views"]
        likes     <- map["likes"]
        duration     <- map["duration"]
        series     <- map["series"]
        likedMe   <- map["inFavorites"]
        viewedMe   <- map["viewedMe"]
        downloadMe   <- map["downloadMe"]
        downloadLink   <- map["downloadLink"]
    }
}

final class SeriesResponse: Mappable {
    var id: Int?
    var name: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["razdId"]
        name     <- map["name"]
    }
}
final class StreamResponse: Mappable {
    var quality: String?
    var link: String?
    
    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        quality       <- map["quality"]
        link     <- map["link"]        
    }
}
