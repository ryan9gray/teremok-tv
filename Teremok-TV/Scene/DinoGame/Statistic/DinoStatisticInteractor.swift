//
//  DinoStatisticInteractor.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DinoStatisticBusinessLogic {
    func fetchStat()
}

protocol DinoStatisticDataStore {
    
}

class DinoStatisticInteractor: DinoStatisticBusinessLogic, DinoStatisticDataStore {
    var presenter: DinoStatisticPresentationLogic?
    let service: DinoServiceProtocol = DinoService()
    
    func fetchStat() {
        service.getStat { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let stats):
                self.presenter?.presentStat(response: stats)
            case .failure(let error):
                self.presenter?.presentError(error: error)
            }
        }
    }

}
