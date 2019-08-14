//
//  ServiceConfiguration.swift
//  vapteke
//
//  Created by R9G on 28.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//


import Foundation
import Alamofire

protocol HostSourceble {
    var baseURLString: String { get }
    var additionalParameters: Parameters { get }
    var deviceID: UUID? { get }
}

enum ServiceConfiguration: String, HostSourceble {
    case prod, sandbox
    
    static func activeConfiguration() -> ServiceConfiguration {
        //
        #if DEBUG
        return .sandbox
        #else
        return .prod
        #endif
    }
    
    var baseURLString: String {
        switch self {
        case .prod:
            return "https://api.teremok.tv/module"
        case .sandbox:
            return "https://api.teremok.tv/module"
        }
    }
    var token: String {
        switch self {
        case .prod:
            return "prod"
        case .sandbox:
            return "sandbox"
        }
    }
    
    var additionalParameters: Parameters {
        var params: [String: Any] = [:]
        params["token"] = token
        return params
    }
    
    var deviceID: UUID? {
        let uuidDevice = UIDevice.current.identifierForVendor?.uuidString
        let potentialGuidMD5 = [uuidDevice, token].allUnwrapapping { $0 }?.reduce("", +).md5HashAsUUID()
        return potentialGuidMD5
    }
    
    var logging: Bool {
        switch self {
        case .prod: return false
        case .sandbox: return true
        }
    }
}
