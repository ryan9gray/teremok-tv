//
//  FavService.swift
//  Teremok-TV
//
//  Created by R9G on 11/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation


protocol FavProtocol {
    func getFavorites(completion: @escaping (Result<GetFavoriteResponse>) -> Void)
    func toSyncDownload(id: [Int])
}

struct FavService: FavProtocol {
    
    func getFavorites(completion: @escaping (Result<GetFavoriteResponse>) -> Void){

        GetFavoritesCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func toSyncDownload(id: [Int]){
        DownloadsSyncCommand(id: id).execute(success: nil, failure: nil)
    }
}
