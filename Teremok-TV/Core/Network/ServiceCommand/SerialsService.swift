//
//  SerialsService.swift
//  Teremok-TV
//
//  Created by R9G on 09/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit


protocol SerialsProtocol {
    func getVideos(itemsOnPage: Int, shiftItem: Int, seriesId: Int, completion: @escaping (Result<VideoResponse>) -> Void)

}

struct SerialsService: SerialsProtocol {
    

    
    func getVideos(itemsOnPage: Int, shiftItem: Int, seriesId: Int, completion: @escaping (Result<VideoResponse>) -> Void) {
        
        VideosCommand(itemsOnPage: itemsOnPage, shiftItem: shiftItem, seriesId: seriesId).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
}
