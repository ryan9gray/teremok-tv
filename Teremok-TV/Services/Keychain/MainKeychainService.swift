//
//  MainKeychainService.swift
//  gu
//
//  Created by tikhonov on 02/06/2017.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation
import KeychainAccess

struct MainKeychainService: KeychainService {
    
    fileprivate let token: String = "ru.xmedia.teremoktv"
    static let sessionKey = "session" + ServiceConfiguration.activeConfiguration().token
    static let sessionPhoneKey = "sessionPhoneKey"
    static let lastRequestToken = "lastRequestToken"
    
    var authSession: String? {
        let keychain = Keychain(service: token)
        return keychain[MainKeychainService.sessionKey]
    }
    
    var lastRequestToken: String? {
        let keychain = Keychain(service: token)
        return keychain[MainKeychainService.lastRequestToken]
    }
    
    func saveLastRequestToken(token: String) {
        let keychain = Keychain(service: self.token)
        keychain[MainKeychainService.lastRequestToken] = token
    }

    
    var phoneSession: String? {
        let keychain = Keychain(service: token)
        return keychain[MainKeychainService.sessionPhoneKey]
    }
    
    func saveAuthSession(session: String) {
        let keychain = Keychain(service: token)
        keychain[MainKeychainService.sessionKey] = session
    }
    
    func savePhoneSession(phone: String) {
        let keychain = Keychain(service: token)
        keychain[MainKeychainService.sessionPhoneKey] = phone
    }
    
    func resetAuthSession() {
        let keychain = Keychain(service: token)
        keychain[MainKeychainService.sessionKey] = ""
    }
    
    func resetPhoneSession() {
        let keychain = Keychain(service: token)
        keychain[MainKeychainService.sessionPhoneKey] = ""
    }
    
    func resetAuthentication() {
        removeUserCache()
        resetAuthSession()
        resetPhoneSession()
    }
    
    func removeUserCache() {
        AppCacher.mappable.clearAllMappable()
        AppCacher.expirable.clearAllExpirable()
        Profile.current = nil
    }
}
