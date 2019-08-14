//
//  AlphaviteStatisticResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class AlphaviteStatisticResponse: Mappable {
    var easy: AnimalsStat?
    var hard: AnimalsStat?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        easy     <- map["easy"]
        hard     <- map["hard"]
    }
}
