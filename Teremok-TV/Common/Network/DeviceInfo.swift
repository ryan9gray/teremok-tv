//
//  DeviceInfo.swift
//  gu
//
//  Created by Sergey Starukhin on 10.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation

struct DeviceInfo {
    
    var guid: UUID = ServiceConfiguration.activeConfiguration().deviceID!
    var objectId: String? = AppInfoWorker.pushToken()
    var userAgent: String = AppInfoWorker.userAgent()
    var mobile: String = AppInfoWorker.deviceModel()
    var appVersion: String = AppInfoWorker.applicationVersion() ?? ""
}

import ObjectMapper

struct UUIDTransform: TransformType {
    typealias Object = UUID
    typealias JSON = String
    
    func transformFromJSON(_ value: Any?) -> UUID? {
        guard let UUIDString = value as? String else { return nil }
        return UUID(uuidString: UUIDString)
    }
    
    func transformToJSON(_ value: UUID?) -> String? {
        if let UUID = value {
            return UUID.uuidString
        }
        return nil
    }
}

extension DeviceInfo: Mappable {
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        guid <- (map["guid"], UUIDTransform())
        objectId <- map["object_id"]
        userAgent <- map["user_agent"]
        mobile <- map["mobile"]
        appVersion <- map["app_version"]
    }
}
