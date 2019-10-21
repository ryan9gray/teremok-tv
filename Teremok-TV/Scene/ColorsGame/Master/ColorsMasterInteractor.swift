//
//  ColorsMasterInteractor.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ColorsMasterBusinessLogic {
    func onDemand(completion: @escaping (Bool) -> Void)
}

protocol ColorsMasterDataStore {
    
}

class ColorsMasterInteractor: ColorsMasterBusinessLogic, ColorsMasterDataStore {
    var presenter: ColorsMasterPresentationLogic?

    let bundleResourceRequest = NSBundleResourceRequest(tags: Set([OnDemandLoader.Tags.Prefetch.colorsGameImage.rawValue, OnDemandLoader.Tags.Prefetch.colorsGameSounds.rawValue]))

    func onDemand(completion: @escaping (Bool) -> Void) {
        bundleResourceRequest.loadingPriority = NSBundleResourceRequestLoadingPriorityUrgent
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] available in
            if available {
                completion(true)
              } else {
                self.bundleResourceRequest.beginAccessingResources { error in
                    completion(error == nil)
                }
              }
        }
    }
}
