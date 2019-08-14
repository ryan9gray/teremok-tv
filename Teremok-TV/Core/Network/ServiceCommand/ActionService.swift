//
//  ActionService.swift
//  Teremok-TV
//
//  Created by R9G on 29/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//


protocol ActionProtocol {
    func toFav(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void)
    func toDownload(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void)
}
struct ActionService: ActionProtocol {
    
    func toFav(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void){
        
        FavCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func toDownload(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void){
        DownloadCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
