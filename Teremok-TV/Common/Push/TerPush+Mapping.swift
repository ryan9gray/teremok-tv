//
//  TTPush+Mapping.swift
//  gu
//
//  Created by Sergey Starukhin on 10.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation
import ObjectMapper

struct TTPushActionTypeTransform: TransformType {
    public typealias Object = TTPushActionType
    public typealias JSON = [String : Any]
    
    let dateTransform: DateFormatterTransform = CustomDateFormatTransform(formatString: "dd.MM.yyyy")
    
    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func transformFromJSON(_ value: Any?) -> TTPushActionType? {
        
        guard let value = value as? [String : Any] else {
            return .unknown
        }
        if let rawPayload = value["payload"] as? [String : Any],
            let payload = Mapper<PushPayload>().map(JSONObject: rawPayload) {
            switch payload.source {
            case .pcs:
                return .pcs(payload.notificationUUID)
            default:
                return .unknown
            }
        }
        guard let action = value["action"] as? String else {
            return .unknown
        }
        switch action {
        case "achieve":
            NotificationCenter.default.post(name: .AchievmentBadge, object: nil, userInfo: ["Ach": 1])
            return .achieve
        case "new_video":
            if let videoId = value["videoId"] as? Int {
                return .newVideo(id: videoId)
            }
        default:
            break
        }
        return .unknown
    }
    
    func transformToJSON(_ value: TTPushActionType?) -> [String : Any]? {
        fatalError("Not implemented")
    }
}

extension TTPush: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        
        switch map.mappingType {
        case .fromJSON:
            if let action = TTPushActionTypeTransform().transformFromJSON(map.JSON) {
                self.action = action
            }
        case .toJSON:
            fatalError("Not implemented")
        }
        aps <- map["aps"]
    }
}

extension TTPush.Aps: Mappable {
    
    struct AlertTypeTransform: TransformType {
        public typealias Object = AlertType
        public typealias JSON = Any
        
        func transformFromJSON(_ value: Any?) -> AlertType? {
            
            if let string = value as? String {
                return .string(string)
            }
            if let jsonObject = value as? [String: Any],
                let object = Mapper<TTPush.Aps.AlertObject>().map(JSON: jsonObject) {
                return .object(object)
            }
            return .empty
        }
        
        func transformToJSON(_ value: AlertType?) -> Any? {
            if let value = value {
                switch value {
                case .string(let string):
                    return string
                case .object(let object):
                    return Mapper<TTPush.Aps.AlertObject>().toJSON(object)
                default:
                    break
                }
            }
            return nil
        }
    }
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        alert <- (map["alert"], AlertTypeTransform())
        badge <- map["badge"]
        sound <- map["sound"]
    }
}

extension TTPush.Aps.AlertType: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .empty:
            return ""
        case .string(let string):
            return string
        case .object(let alert):
            return alert.title
        }
    }
}

extension TTPush.Aps.AlertObject: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        title <- map["title"]
        body <- map["body"]
    }
}
