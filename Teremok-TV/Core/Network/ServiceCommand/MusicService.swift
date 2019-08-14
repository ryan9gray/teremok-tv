//
//  MusicService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 30/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

protocol MainMusicProtocol {
    func getMain(itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<MusicContentResponse>) -> Void)
}

struct MusicService: MainMusicProtocol {

    func getMain(itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<MusicContentResponse>) -> Void) {
        MusicMainCommand(itemsOnPage: itemsOnPage, shiftItem: shiftItem).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
