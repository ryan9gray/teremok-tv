//
//  AnimalsSendStat.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 12/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class AnimalsSendStatCommand: BasicCommand {
    let difficulty: Int
    let pack: Int
    let duration: Int
    let correctCount: Int
    let totalCount: Int
    let round: Int

    init(difficulty: Int, pack: Int, duration: Int, correctCount: Int, totalCount: Int, round: Int) {
        self.difficulty = difficulty
        self.pack = pack
        self.duration = duration
        self.correctCount = correctCount
        self.totalCount = totalCount
        self.round = round
    }

    func execute(success: ((StatusResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.AnimalsGame.sendStat.methodName
    }

    override var parameters: [String : Any] {
        return [
            "difficulty" : difficulty,
            "pack": pack,
            "duration" : duration,
            "cnt_correct" : correctCount,
            "cnt_total" : totalCount,
            "round" : round
        ]
    }
}
