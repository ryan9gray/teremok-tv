//
//  LocalStore.swift
//  Asko
//
//  Created by Ryan9Gray on 11.08.16.
//  Copyright © 2016 DoubleDevTeam. All rights reserved.
//

import UIKit


struct LocalStore {
    fileprivate static let accessTokenKey = "accessTokenKey"
    fileprivate static let firstLaunchKey = "firstLaunchKey"
    fileprivate static let pushTokenKey = "pushTokenKey"
    fileprivate static let rateVersionKey = "rateVersion"
    fileprivate static let appOpenedCoundKey = "appOpenedCound"
    fileprivate static let migrationKey = "migration"
    fileprivate static let analiticsKey = "analitics"

    fileprivate static let alphaviteIntroduceKey = "alphaviteIntroduceKey"
    fileprivate static let animalFirstIntroduce = "animalFirstIntroduce"
    fileprivate static let animalSecondIntroduce = "animalSecondIntroduce"
    fileprivate static let animalThirdIntroduce = "animalThirdIntroduce"
    fileprivate static let animalsDifficultyKey = "animalsDifficultyKey"
    fileprivate static let alphaviteDifficultyKey = "alphaviteDifficultyKey"

    fileprivate static let userDefaults = UserDefaults.standard

    static var animalsIsHard: Bool {
        get {
            return userDefaults.bool(forKey: animalsDifficultyKey)
        }
        set {
            userDefaults.set(newValue, forKey: animalsDifficultyKey)
            userDefaults.synchronize()
        }
    }

    static var alphaviteIsHard: Bool {
        get {
            return userDefaults.bool(forKey: alphaviteDifficultyKey)
        }
        set {
            userDefaults.set(newValue, forKey: alphaviteDifficultyKey)
            userDefaults.synchronize()
        }
    }

    static var lastRateVersion: String? {
        get {
            return userDefaults.string(forKey: rateVersionKey)
        }
        set {
            userDefaults.set(newValue, forKey: rateVersionKey)
            userDefaults.synchronize()
        }
    }

    // in current version
    static var appOpenedCount: Int {
        get {
            return userDefaults.integer(forKey: appOpenedCoundKey)
        }
        set {
            userDefaults.set(newValue, forKey: appOpenedCoundKey)
            userDefaults.synchronize()
        }
    }

    static var alphabetTip: Int {
        get {
            return userDefaults.integer(forKey: "alphabetTip")
        }
        set {
            userDefaults.set(newValue, forKey: "alphabetTip")
            userDefaults.synchronize()
        }
    }

    static var animalsTip: Int {
        get {
            return userDefaults.integer(forKey: "animalsTip")
        }
        set {
            userDefaults.set(newValue, forKey: "animalsTip")
            userDefaults.synchronize()
        }
    }

    static var analiticsLastSend: Double {
        get {
            return userDefaults.double(forKey: analiticsKey)
        }
        set {
            userDefaults.set(newValue, forKey: analiticsKey)
            userDefaults.synchronize()
        }
    }

    static func pushToken() -> String? {
        return userDefaults.string(forKey: pushTokenKey)
    }

    static func firstLaunch() -> Bool {
        if userDefaults.bool(forKey: firstLaunchKey){
            return false
        }
        else{
            return true
        }
    }

    // for later
    static func migration() -> Bool {
        if userDefaults.bool(forKey: migrationKey) {
            userDefaults.set(true, forKey: migrationKey)
            userDefaults.synchronize()
            return false
        }
        else{
            return true
        }
    }

    static func setfirstLaunch(){
        userDefaults.set(true, forKey: firstLaunchKey)
        userDefaults.synchronize()
    }
    
    static func logout() {
        userDefaults.removeObject(forKey: accessTokenKey)
        userDefaults.synchronize()
        
    }

    // MARK: Introduce Video
    static func firstAnimalsIntroduce() -> Bool {
        if !userDefaults.bool(forKey: animalFirstIntroduce){
            userDefaults.set(true, forKey: animalFirstIntroduce)
            userDefaults.synchronize()
            return true
        }
        else{
            return false
        }
    }
    static func secondAnimalsIntroduce() -> Bool {
        if !userDefaults.bool(forKey: animalSecondIntroduce){
            userDefaults.set(true, forKey: animalSecondIntroduce)
            userDefaults.synchronize()
            return true
        }
        else{
            return false
        }
    }

    static func alphaviteIntroduce() -> Bool {
        if !userDefaults.bool(forKey: alphaviteIntroduceKey){
            userDefaults.set(true, forKey: alphaviteIntroduceKey)
            userDefaults.synchronize()
            return true
        }
        else{
            return false
        }
    }
}
