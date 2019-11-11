//
//  AppLaunchInfoDefaults.swift
//  gu
//
//  Created by klementev on 09/07/2018.
//  Copyright © 2018 tt. All rights reserved.
//

import Foundation

class AppLaunchInfoDefaults: DefaultsObject {
    var appVersion: String? = AppInfoWorker.applicationVersion()
    // для текущей версии версии приложения
    var firstAppLaunchDate: Date?
    var launchesCount: Int = 0
    
    required override init() {
        super.init()
    } 
}
class HLSAssets: DefaultsObject {
    var assets: [Stream]?

    required override init() {
        super.init()
    }
}
