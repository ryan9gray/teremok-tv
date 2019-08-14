//
//  AppInfoWorker.swift
//  vapteke
//
//  Created by R9G on 28.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import UIKit

class AppInfoWorker {
    static func applicationName() -> String? {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String
    }
    
    static func applicationVersion() -> String? {
        let bundleInfoDict = Bundle.main.infoDictionary
        var version = bundleInfoDict?["CFBundleShortVersionString"] as? String ?? ""
        version = version.trimmingCharacters(in: CharacterSet(charactersIn: "01234567890.").inverted)
        let build = bundleInfoDict?["CFBundleVersion"] as? String ?? ""
        return "\(version) (\(build))"
    }
    
    static var applicationShortVersion: String {
        let bundleInfoDict = Bundle.main.infoDictionary
        var appShortVersion: String = bundleInfoDict?["CFBundleShortVersionString"] as? String ?? ""
        appShortVersion.removeLast()
        return appShortVersion
    }
    
    static var buildVersion: String {
        let bundleInfoDict = Bundle.main.infoDictionary
        let build = bundleInfoDict?["CFBundleVersion"] as? String ?? ""
        return build
    }
    
    static var isHaveCloudToken: Bool {
        return !(pushToken()?.isEmpty ?? true)
    }
    
    static var isPushNotificationsAllowed: Bool {
        return UIApplication.shared.isRegisteredForRemoteNotifications
    }
    
    static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static func systemName() -> String {
        return UIDevice.current.systemName
    }
    
    static func systemFullName() -> String {
        return systemName() + " " + systemVersion()
    }
    
    static func deviceModel() -> String {
        return UIDevice.current.modelName
    }
    
    static func userAgent() -> String {
        return "ios"
    }
    
    static func updateCloudToken(_ token: Data?) {
        var tokenString: String?
        
        if let token = token {
            tokenString = token.reduce("", {$0 + String(format: "%02X", $1)})
        }
        UserDefaults.standard.set(tokenString, forKey: "pushToken")
    }
    
    static func pushToken() -> String? {
        return UserDefaults.standard.string(forKey: "pushToken")
    }
    
}
