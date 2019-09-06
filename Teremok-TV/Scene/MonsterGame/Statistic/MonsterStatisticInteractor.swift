//
//  MonsterStatisticInteractor.swift
//  Teremok-TV
//
//  Created by Дмитрий Грищенко on 03/09/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MonsterStatisticBusinessLogic {
    func fetchStat()
}

protocol MonsterStatisticDataStore {
    
}

class MonsterStatisticInteractor: MonsterStatisticBusinessLogic, MonsterStatisticDataStore {
    var presenter: MonsterStatisticPresentationLogic?
    let service: MonsterServiceProtocol = MonsterService()
    
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
