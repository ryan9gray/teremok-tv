//
//  AnimalsGetPackCommand.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class AnimalsGetPackCommand: BasicCommand {
    let id: Int

    init(id: Int) {
        self.id = id
    }

    func execute(success: (([AnimalsPackResponse]) -> Void)?, failure: ApiCompletionBlock?) {
        requestObjectArray(success: success, failure: failure, path: "pack")
    }

    override var method: String {
        return APIMethod.AnimalsGame.getPack.methodName
    }

    override var parameters: [String : Any] {

        return [ "id": id ]
    }
}
