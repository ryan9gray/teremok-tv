//
//  SigninResponse.swift
//  vapteke
//
//  Created by R9G on 28.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//


import ObjectMapper



final class RegistrResponse: Mappable {
    
    var uToken: String?
    var userID: Int?
    var state: String?
    var childProfile: Child?

    // Mappable
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        uToken        <- map["X-Session-ID"]
        userID     <- map["userID"]
        state   <- map["state"]
        childProfile     <- map["ChildProfile"]

    }
}


final class AddChildResponse: Mappable {
    
    var childProfile: Child?

    
    // Mappable
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {

        childProfile     <- map["ChildProfile"]
    }
}
final class StateResponse: Mappable {
    
    var state: String?

    // Mappable
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        state   <- map["state"]
    }
}
