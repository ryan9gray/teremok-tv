//
//  AlphabetService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

protocol AlphabetServiceProtocol {
    func getStat(completion: @escaping (Result<AlphaviteStatisticResponse>) -> Void)
    func sendStat(statistic: [AlphaviteStatistic], completion: @escaping (Result<StatusResponse>) -> Void)
}

struct AlphabetService: AlphabetServiceProtocol {
    func getStat(completion: @escaping (Result<AlphaviteStatisticResponse>) -> Void) {
        AlphabetGetStatCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func sendStat(statistic: [AlphaviteStatistic], completion: @escaping (Result<StatusResponse>) -> Void) {
        AlphabetSendStatCommand(stats: statistic).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
