//
//  AnimalsMasterInteractor.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 18/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AnimalsMasterBusinessLogic {
    func changeComplexity(isEasy: Bool)
    func onDemand(completion: @escaping (Bool) -> Void)
}

protocol AnimalsMasterDataStore {
    var isEasy: Bool { get set }
}

class AnimalsMasterInteractor: AnimalsMasterBusinessLogic, AnimalsMasterDataStore {
    var presenter: AnimalsMasterPresentationLogic?
    var isEasy = true

    func changeComplexity(isEasy: Bool) {
        self.isEasy = isEasy
    }
    let bundleResourceRequest = NSBundleResourceRequest(tags:
           Set([OnDemandLoader.Tags.Prefetch.animalsSounds.rawValue, OnDemandLoader.Tags.Prefetch.animalsImage.rawValue])
    )
    func onDemand(completion: @escaping (Bool) -> Void) {
        bundleResourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] available in
            if available {
                completion(true)
              } else {
                self.bundleResourceRequest.beginAccessingResources { error in
                    NotificationCenter.default.post(name: .UploadProgress, object: self.bundleResourceRequest.progress.fractionCompleted)
                    completion(false)
                  }
              }
        }
    }
}
