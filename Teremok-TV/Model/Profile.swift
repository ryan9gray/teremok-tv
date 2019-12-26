//
//  User.swift
//  Teremok-TV
//
//  Created by R9G on 25/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireImage

public enum Sex: String, Codable {
    case man = "man"
    case woman = "woman"
    
    var kid: String {
        switch self {
        case .man:
            return "мальчик"
        case .woman:
            return "девочка"
        }
    }
}

final class Profile: Mappable  {
    
    static var current: Profile? = AppCacher.mappable.getObject(of: Profile.self) {
        didSet {
            NotificationCenter.default.post(name: NSNotification.Name.ProfileDidChanged, object: current)
        }
    }

    static var currentChild: Child? {
        return Profile.current?.childs.filter {$0.current ?? false}.first
    }

    static var isAuthorized: Bool {
		return !(current?.needAuthorize ?? true)
    }

	var needAuthorize: Bool = true

    static var subscribe: String {
        if let profile = Profile.current {
            switch profile.currentPremium() {
                case .game:
                    return "У Вас подписка «Интеллектум»"
                case .music:
                    return "У Вас подписка «Дети Супер +»"
                case .offline:
                    return "У Вас подписка «Дети+»"
                case .simple:
                    return "Вас нет подписки"
            }
        }
        return "Вы не авторизованы"
    }
    
    var id: Int?
    var email: String?
    var childs: [Child] = []

    func currentPremium() -> Premium {
        if premiumGame {
            return .game
        } else if premiumMusic {
            return .music
        } else if premium {
            return .offline
        } else {
            return .simple
        }
    }
    
    var premium: Bool = false
    var premiumMusic: Bool = false
    var premiumGame: Bool = false

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        email <- map["email"]
        id <- map["id"]
        childs <- map["childs"]
        premium     <- map["premium"]
        premiumMusic     <- map["premiumMusic"]
        premiumGame     <- map["premiumGame"]
		needAuthorize     <- map["needAuthorize"]
    }
    
    init(with profile: ProfileResponse) {
        let map = Map(mappingType: .fromJSON, JSON: Mapper<ProfileResponse>().toJSON(profile))
        mapping(map: map)
    }
    func updateDataWith(_ profileRequest: ProfileResponse) {
        let map = Map(mappingType: .fromJSON, JSON: Mapper<ProfileResponse>().toJSON(profileRequest))
        mapping(map: map)
    }
}

enum Premium {
    case offline
    case music
    case game
    case simple
}

final class Child: Mappable  {
    var name: String?
    var id: String?
    var pic: String?
    var current: Bool?
    var birthdate: Date?
    var sex: Sex?
    
    var birthDateString: String? {
        if let bd = self.birthdate {
            return formatter.string(from: bd)
        }
        return ""
    }
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id       <- map["id"]
        name     <- map["name"]
        sex     <- map["sex"]
        pic     <- map["pic"]
        current     <- map["current"]
        birthdate <- (map["birthdate"], CustomDateFormatTransform(formatString: "dd.MM.yyyy"))
    }
    init(with profile: ChildResponse) {
        let map = Map(mappingType: .fromJSON, JSON: Mapper<ChildResponse>().toJSON(profile))
        mapping(map: map)
    }
    func updateDataWith(_ profileRequest: ChildResponse) {
        let map = Map(mappingType: .fromJSON, JSON: Mapper<ChildResponse>().toJSON(profileRequest))
        mapping(map: map)
    }
}
