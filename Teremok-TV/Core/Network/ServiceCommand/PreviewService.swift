//
//  PreviewService.swift
//  Teremok-TV
//
//  Created by R9G on 26/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit


protocol PreviewProtocol {
    func getVideo(id: Int, razdId: Int?, completion: @escaping (Result<VideoItemModel>) -> Void)
}

struct PreviewService: PreviewProtocol {
    
    
    func getVideo(id: Int, razdId: Int?, completion: @escaping (Result<VideoItemModel>) -> Void) {
        
        VideoItemCommand(videoId: id, razdId: razdId).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
}
