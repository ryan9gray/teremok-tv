//
//  OnDemandLoader.swift
//  Teremok-TV
//
//  Created by Eugene Ivanov on 18/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//
import Foundation

class OnDemandLoader {
    private lazy var bundleResourceRequest = NSBundleResourceRequest(tags: Set(["IntroducingVideo"]))

    func loadOnDemandAssets() {
        bundleResourceRequest.conditionallyBeginAccessingResources { [unowned self] (available) in
            if available {
                //self.loadOnboardingAssets()
            } else {
                self.bundleResourceRequest.beginAccessingResources { (error) in
                    guard error == nil else { return }
                    //self.loadOnboardingAssets()
                }
            }
        }
    }

    private func discardOnDemandAssets() {
        bundleResourceRequest.endAccessingResources()
    }
}
