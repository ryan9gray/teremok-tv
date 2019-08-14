//
//  MusicActionService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 11/04/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

protocol MusicActionProtocol {
    func toFav(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void)
    func toDownload(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void)
    func toPlayed(with id: Int, completion: @escaping (Result<ViewsResponse>) -> Void)
}

struct MusicActionService: MusicActionProtocol {

    func toFav(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void){
        FavTrackCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func toDownload(with id: Int, completion: @escaping (Result<ActionResponse>) -> Void) {
        DownloadTrackCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func toPlayed(with id: Int, completion: @escaping (Result<ViewsResponse>) -> Void) {
        ListenTrackCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
