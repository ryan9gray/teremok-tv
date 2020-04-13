//
//  DinoStatisticResponse.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 13.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import ObjectMapper

final class DinoStatisticResponse: Mappable {
    var daysToUpdate: Int = 0
    var currentweek: WeekTime!
    var pastweek: WeekTime!
    init?(map: Map) {}
    
    func mapping(map: Map) {
        daysToUpdate <- map["daysToUpdate"]
        currentweek <- map["currentweek"]
        pastweek <- map["pastweek"]
    }
    
    final class WeekTime: Mappable {
        var time: Int = 0
        init?(map: Map) {}
        
        func mapping(map: Map) {
            time <- map["avgtime"]
        }
    }
}

final class DinoStatisticRequest: Mappable {
    var round: Int = 0
    var seconds: Int = 0
    
    init(round: Int, seconds: Int) {
        self.round = round
        self.seconds = seconds
    }
    
    init?(map: Map) {}
    
    func mapping(map: Map) {
        round <- map["round"]
        seconds <- map["seconds"]
    }
}
