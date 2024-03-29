//
//  AnimalsStatisticInteractor.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AnimalsStatisticBusinessLogic {
    func fetchStat()
}

protocol AnimalsStatisticDataStore {
    var isEasy: Bool { get set }
}

class AnimalsStatisticInteractor: AnimalsStatisticBusinessLogic, AnimalsStatisticDataStore {
    var presenter: AnimalsStatisticPresentationLogic?
    let service: AnimalsGameProtocol = AnimalsGameService()

    var isEasy: Bool = true

    func fetchStat() {
        service.getStat { [weak self] result in
            switch result {
            case .success(let response):
                self?.response(response)
            case .failure(let error):
                self?.presenter?.presentError(error: error)
            }
        }
    }

    func response(_ reponse: AnimalsStatResponse) {
        presenter?.presentStats(response: reponse)
    }
}
