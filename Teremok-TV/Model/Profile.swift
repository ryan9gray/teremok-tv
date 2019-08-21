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
        return current != nil
    }

    static var subscribe: String {
        if let profile = Profile.current {
            if profile.premiumGame {
                return "У Вас подписка «Дети+»"
            } else if profile.premiumMusic {
                return "У Вас подписка «Дети Супер +»"
            } else if profile.premium {
                return "У Вас подписка «Интеллектум»"
            } else {
                return "Вас нет подписки"
            }
        }
        return "Вы не авторизованы"
    }
    
    var id: Int?
    var email: String?
    var childs: [Child] = []
    
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


final class Child: Mappable  {

    var name: String?
    var id: String?
    var pic: String?
    var current: Bool?
    
    var birthdate: Date?
    /** Пол */
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
struct DateModel {
    var date: String?
    var formattingDateString: String?
    
    init(date: String?, formattingDateString: String?) {
        self.date = date
        self.formattingDateString = formattingDateString
    }
    
    init?(date: Date, format: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.timeZone = TimeZone.current
        
        let dateString = dateFormatter.string(from: date)
        self.date = dateString
        if date.startOfDay == Date().startOfDay {
            formattingDateString = "Сегодня"
        } else {
            formattingDateString = date.short2DateString
        }
    }
}
