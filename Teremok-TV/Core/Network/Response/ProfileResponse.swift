//
//  GetProfileResponse.swift
//  Teremok-TV
//
//  Created by R9G on 11/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import ObjectMapper


final class GetProfileResponse: Mappable {
    
    var profile: ProfileResponse?
    
    var statistic: Statistic?
    
    var lastViewedVideos: [VideoModel]?
    var favorite: [VideoModel]?

    
    // Mappable
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        profile       <- map["profile"]
        lastViewedVideos     <- map["lastViewedVideos"]
        favorite     <- map["favorite"]
        statistic     <- map["statistic"]
    }
}
final class ProfileResponse: Mappable {
    var id: Int?
    var email: String?
    var childs: [ChildResponse] = []
	var needRegistrate: Bool = true
	var premium: Bool = false
    var premiumMusic: Bool = false
    var premiumGame: Bool = false

    init(with profile: Profile) {
        let map = Map(mappingType: .fromJSON, JSON: Mapper<Profile>().toJSON(profile))
        mapping(map: map)
    }
    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id       <- map["id"]
        email     <- map["email"]
        premium     <- map["premium"]
        childs     <- map["childs"]
        premiumMusic     <- map["premiumMusic"]
        premiumGame     <- map["premiumGame"]
    }
}

final class Statistic: Mappable {
    var viewedVideos: Int?
    var downloadViedos: Int?
    var likedVideos: Int?
    
    // Mappable
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        viewedVideos       <- map["viewedVideos"]
        downloadViedos     <- map["downloadViedos"]
        likedVideos     <- map["likedVideos"]
    }
}

final class ChildResponse: Mappable {
    
    var id: String?
    var name: String?
    var pic: String?
    var deleted: String?
    var current: Bool?
    var birthdate: Date?
    var sex: Sex?

    // Mappable
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        pic     <- map["pic"]
        sex     <- map["sex"]
        deleted     <- map["deleted"]
        current     <- map["current"]
        birthdate <- (map["birthdate"], CustomDateFormatTransform(formatString: "dd.MM.yyyy"))

    }
    init(with profile: Child) {
        let map = Map(mappingType: .fromJSON, JSON: Mapper<Child>().toJSON(profile))
        mapping(map: map)
    }
}
final class GetFavoriteResponse: Mappable {
    var favorite: [VideoModel]?

    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        favorite     <- map["favorite"]
        
    }
}
final class EditChildResponse: Mappable {
    
    var childProfile: Child?

    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        childProfile     <- map["ChildProfile"]
    }
}
