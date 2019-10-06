//
//  ColorsGameService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 05/10/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

protocol ColorsGameServiceProtocol {
    func getStat(completion: @escaping (Result<AlphaviteStatisticResponse>) -> Void)
    func sendStat(statistic: [AlphaviteStatistic], completion: @escaping (Result<StatusResponse>) -> Void)
}

struct ColorsGameService: ColorsGameServiceProtocol {
    func getStat(completion: @escaping (Result<AlphaviteStatisticResponse>) -> Void) {
        ColorsGameGetStatCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func sendStat(statistic: [AlphaviteStatistic], completion: @escaping (Result<StatusResponse>) -> Void) {
        ColorsGameSendStatCommand(stats: statistic).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
