//
//  DinoMasterInteractor.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 06.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DinoMasterBusinessLogic {
    func onDemand(completion: @escaping (Bool) -> Void)
}

protocol DinoMasterDataStore {
}

class DinoMasterInteractor: DinoMasterBusinessLogic, DinoMasterDataStore {
    var presenter: DinoMasterPresentationLogic?
    let bundleResourceRequest = NSBundleResourceRequest(tags: Set([OnDemandLoader.Tags.Prefetch.dinoImage.rawValue]))

    func onDemand(completion: @escaping (Bool) -> Void) {
        bundleResourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] available in
            if available {
                completion(true)
              } else {
                self.bundleResourceRequest.beginAccessingResources { error in
                    completion(false)
                  }
              }
        }
    }

}
