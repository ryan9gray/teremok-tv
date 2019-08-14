//
//  AppUpdateDefaults.swift
//  gu
//
//  Created by Армен Алумян on 22.01.2018.
//  Copyright © 2018 tt. All rights reserved.
//
import Foundation

@objcMembers
final class AppUpdateDefaults: DefaultsObject {
    var periodicity: Int = 1 // minutes
    var lastShownDate: Date?
    var lastUsedVersion: String? = nil
    var lastStatsSendDate: Date?
    
    static var shouldShowNewFeaturesAlert: Bool {
        let defaults = AppUpdateDefaults.fromDefaults()
        let bundleInfoDict = Bundle.main.infoDictionary
        let currentVersion: String = bundleInfoDict?["CFBundleShortVersionString"] as? String ?? ""
        let differentVersions: Bool = currentVersion != defaults.lastUsedVersion
        defaults.lastUsedVersion = currentVersion
        defaults.saveToDefaults()
        return differentVersions
    }
    
    required override init() {
        super.init()
    }
}


