//
//  ContentCommands.swift
//  Teremok-TV
//
//  Created by R9G on 12/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

class ViewVideoCommand: BasicCommand {
    
    let id: Int
    let currentPosition: Int

    init(id: Int, currentPosition: Int) {
        self.id = id
        self.currentPosition = currentPosition
    }
    
    func execute(success: ((ViewsResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Actions.viewVideo.methodName
    }

    override var parameters: [String : Any] {
        return ["id": id, "currentPosition": currentPosition]
    }
}

class DownloadCommand: BasicCommand {
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    func execute(success: ((ActionResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Actions.downloadVideo.methodName
    }
    
    override var parameters: [String : Any] {
        return ["id": id]
    }
}

class DownloadsSyncCommand: BasicCommand {
    
    let id: [Int]
    
    init(id: [Int]) {
        self.id = id
    }
    func execute(success: ((ActionResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Actions.downloadsSync.methodName
    }
    
    override var parameters: [String : Any] {
        return ["videosID": id]
    }
}

class FavCommand: BasicCommand {
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    func execute(success: ((ActionResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Actions.favVideo.methodName
    }
    
    override var parameters: [String : Any] {
        return ["id": id]
    }
}
class LikeCommand: BasicCommand {
    
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    func execute(success: ((LikeResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Actions.likeVideo.methodName
    }
    
    override var parameters: [String : Any] {
        return ["id": id]
    }
}
