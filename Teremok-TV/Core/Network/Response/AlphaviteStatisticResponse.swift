//
//  AlphaviteStatisticResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class AlphaviteStatisticResponse: Mappable {
    var good: [AlphabetStat] = []
    var bad: [AlphabetStat] = []

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        good     <- map["good"]
        bad     <- map["bad"]
    }
}

final class AlphabetStat: Mappable {
    var char: String = ""
    var value: String = ""

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        char     <- map["char"]
        value     <- map["value"]
    }
}

final class AlphaviteStatistic: Mappable {
    var char: String = ""
    var seconds: Int = 0
    var isRight: Bool = false

    init(char: String, seconds: Int, isRight: Bool) {
        self.char = char
        self.seconds = seconds
        self.isRight = isRight
    }
    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        char     <- map["char"]
        seconds     <- map["seconds"]
        isRight     <- map["isRight"]
    }
}
