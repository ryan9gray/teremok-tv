//
//  MonsterService.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 03/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

protocol MonsterServiceProtocol {
    func getStat(completion: @escaping (Result<MonsterStatisticResponse>) -> Void)
    func sendStat(statistic: [MonsterStatisticRequest], completion: @escaping (Result<StatusResponse>) -> Void)
}

struct MonsterService: MonsterServiceProtocol {
    func getStat(completion: @escaping (Result<MonsterStatisticResponse>) -> Void) {
        MonsterGetStatCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func sendStat(statistic: [MonsterStatisticRequest], completion: @escaping (Result<StatusResponse>) -> Void) {
        MonsterSendStatCommand(stats: statistic).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
