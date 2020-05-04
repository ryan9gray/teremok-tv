//
//  DinoService.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 13.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DinoServiceProtocol {
    func getStat(completion: @escaping (Result<DinoStatisticResponse>) -> Void)
    func sendStat(statistic: DinoStatisticRequest, completion: @escaping (Result<StatusResponse>) -> Void)
}

struct DinoService: DinoServiceProtocol {
    func getStat(completion: @escaping (Result<DinoStatisticResponse>) -> Void) {
        DinoGetStatCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func sendStat(statistic: DinoStatisticRequest, completion: @escaping (Result<StatusResponse>) -> Void) {
        DinoSendStatCommand(stats: statistic).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
