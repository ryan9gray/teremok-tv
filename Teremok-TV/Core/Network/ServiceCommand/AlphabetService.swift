//
//  AlphabetService.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

protocol AlphabetServiceProtocol {
    func getStat(completion: @escaping (Result<AlphaviteStatisticResponse>) -> Void)
    func sendStat(statistic: [AlphaviteMaster.Statistic], completion: @escaping (Result<StatusResponse>) -> Void)
}

struct AlphabetService: AlphabetServiceProtocol {
    func getStat(completion: @escaping (Result<AlphaviteStatisticResponse>) -> Void) {

    }
    func sendStat(statistic: [AlphaviteMaster.Statistic], completion: @escaping (Result<StatusResponse>) -> Void) {
        
    }

}
