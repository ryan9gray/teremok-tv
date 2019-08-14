//
//  SearchMusicService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 14/04/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

protocol SearchMusicProtocol {
    func search(phrase: String, itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<MusicSearchtResponse>) -> Void)
    func searchVar(phrase: String, completion: @escaping (Result<SearchVarsResponse>) -> Void)
}

struct SearchMusicService: SearchMusicProtocol {

    func search(phrase: String, itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<MusicSearchtResponse>) -> Void){
        MusicSearchCommand(phrase: phrase, itemsOnPage: itemsOnPage, shiftItem: shiftItem)
            .execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    func searchVar(phrase: String, completion: @escaping (Result<SearchVarsResponse>) -> Void){
        MusicSearchVarsCommand(phrase: phrase)
            .execute(success: { (responseObject) in
                completion(.success(responseObject))
            }) { (com, response) in
                if let error = response.error {
                    completion(.failure(error))
                }
        }
    }
}
