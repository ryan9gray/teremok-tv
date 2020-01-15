//
//  StoreReviewHelper.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 23/04/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {

   	static func checkAndAskForReview() {
        guard ServiceConfiguration.activeConfiguration() == .prod  else {
            return
        }
        let appOpenCount = LocalStore.appOpenedCount
        switch appOpenCount {
        case 30:
            StoreReviewHelper.requestReview()
        case _ where appOpenCount % 100 == 0 :
            StoreReviewHelper.requestReview()
        default:
            print("App run count in this version is : \(appOpenCount)")
            break
        }
    }
	
    fileprivate static func requestReview() {
        if #available(iOS 10.3, *) {
            LocalStore.lastRateVersion = AppInfoWorker.applicationShortVersion
            LocalStore.appOpenedCount = 0
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            // Try any other 3rd party or manual method here.
        }
    }
}
