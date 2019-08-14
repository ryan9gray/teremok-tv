//
//  AnimalsGameService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//


protocol AnimalsGameProtocol {
    func getListPacks(completion: @escaping (Result<AnimalsListResponse>) -> Void)
    func getPack(id: Int, completion: @escaping (Result<[AnimalsPackResponse]>) -> Void)
    func getStat(completion: @escaping (Result<AnimalsStatResponse>) -> Void)
    func sendStat(difficulty: Int, pack: Int, duration: Int, correctCount: Int, totalCount: Int, round: Int, completion: @escaping (Result<StatusResponse>) -> Void)
}

struct AnimalsGameService: AnimalsGameProtocol {

    func getListPacks(completion: @escaping (Result<AnimalsListResponse>) -> Void) {
        ListPacksCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func getPack(id: Int, completion: @escaping (Result<[AnimalsPackResponse]>) -> Void) {
        AnimalsGetPackCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func sendStat(difficulty: Int, pack: Int, duration: Int, correctCount: Int, totalCount: Int, round: Int, completion: @escaping (Result<StatusResponse>) -> Void) {
        AnimalsSendStatCommand(difficulty: difficulty, pack: pack, duration: duration, correctCount: correctCount, totalCount: totalCount, round: round)
            .execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func getStat(completion: @escaping (Result<AnimalsStatResponse>) -> Void) {
        AnimalsGetStatCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}

