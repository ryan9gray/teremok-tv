//
//  PlaylistService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 30/03/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

protocol PlaylistServiceProtocol {
    func getPlaylist(id: Int, completion: @escaping (Result<MusicPlaylistResponse>) -> Void)
    func syncDownload(ids: [Int], completion: @escaping (Result<ActionResponse>) -> Void)
}

struct MainPlaylistService: PlaylistServiceProtocol {
    func getPlaylist(id: Int, completion: @escaping (Result<MusicPlaylistResponse>) -> Void) {
        MusicPlaylistCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func syncDownload(ids: [Int], completion: @escaping (Result<ActionResponse>) -> Void) {
        DownloadsMusicSyncCommand(id: ids).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
