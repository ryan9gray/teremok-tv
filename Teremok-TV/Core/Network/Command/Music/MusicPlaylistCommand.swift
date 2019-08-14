//
//  MusicPlaylistCommand.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 30/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Alamofire

class MusicPlaylistCommand: BasicCommand {
    let id: Int

    init(id: Int) {
        self.id = id
    }

    func execute(success: ((MusicPlaylistResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.playlist.methodName
    }

    override var parameters: [String : Any] {
        return [ "id": id ]
    }
}
