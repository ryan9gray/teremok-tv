//
//  MusicActions.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 30/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

class DownloadTrackCommand: BasicCommand {
    let id: Int

    init(id: Int) {
        self.id = id
    }
    func execute(success: ((ActionResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.downloadTrack.methodName
    }

    override var parameters: [String : Any] {

        return ["id": id]
    }
}

class DownloadsMusicSyncCommand: BasicCommand {
    let id: [Int]

    init(id: [Int]) {
        self.id = id
    }
    func execute(success: ((ActionResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.downloadsSync.methodName
    }

    override var parameters: [String : Any] {
        return ["tracksID": id]
    }
}

class FavTrackCommand: BasicCommand {
    let id: Int

    init(id: Int) {
        self.id = id
    }
    func execute(success: ((ActionResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.favTrack.methodName
    }

    override var parameters: [String : Any] {
        return ["id": id]
    }
}

class ListenTrackCommand: BasicCommand {
    let id: Int

    init(id: Int) {
        self.id = id
    }

    func execute(success: ((ViewsResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }

    override var method: String {
        return APIMethod.Music.listenTrack.methodName
    }

    override var parameters: [String : Any] {
        return ["id": id ]
    }
}
