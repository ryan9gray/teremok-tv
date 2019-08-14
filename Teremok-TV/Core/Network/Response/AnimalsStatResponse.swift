//
//  AnimalsStatResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 12/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

final class AnimalsStatResponse: Mappable {
    var easy: AnimalsStat?
    var hard: AnimalsStat?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        easy     <- map["easy"]
        hard     <- map["hard"]
    }
}

final class AnimalsStat: Mappable {
    var rightAnswers: String?
    var percent: String?
    var speed: String?

    // Mappable
    required init?(map: Map) {}

    func mapping(map: Map) {
        rightAnswers     <- map["rightAnswers"]
        percent     <- map["percent"]
        speed     <- map["speed"]
    }
}
