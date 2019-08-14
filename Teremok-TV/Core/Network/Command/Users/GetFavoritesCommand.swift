//
//  GetFavoritesCommand.swift
//  Teremok-TV
//
//  Created by R9G on 11/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation


class GetFavoritesCommand: BasicCommand {
    
    func execute(success: ((GetFavoriteResponse) -> Void)?, failure: ApiCompletionBlock?) {
        requestObject(success: success, failure: failure)
    }
    
    override var method: String {
        return APIMethod.Profile.getFavorites.methodName
    }
    
    override var parameters: [String : Any] {
        return [:]
    }
}
