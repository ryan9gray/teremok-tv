//
//  PushPayload.swift
//  gu
//
//  Created by Sergey Starukhin on 28.09.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation

struct PushPayload {
    
    enum Source: String {
        case unknown
        case pcs
    }
    var source: Source = .unknown
    var notificationUUID: UUID = UUID(uuidString: "00000000-0000-0000-0000-000000000000")!
}

import ObjectMapper

extension PushPayload: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        source <- map["source"]
        notificationUUID <- (map["notification_uuid"], UUIDTransform())
    }
}
