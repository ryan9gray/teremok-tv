//
//  EventsLogCommand.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 27/07/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import ObjectMapper

class EventsLogCommand: BasicCommand {
    let events: [String : String]

    init(events: [String : String]) {
        self.events = events
    }

    func execute(success: ((StatusResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Analytic.eventsLog.methodName
    }

    override var parameters: [String : Any] {
        return [ "events": events ]
    }
}
