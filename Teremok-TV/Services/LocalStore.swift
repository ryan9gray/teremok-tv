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
    fileprivate static let colorsDifficultyKey = "colorsDifficultyKey"
    fileprivate static let colorsGameIntroduceKey = "colorsGameIntroduceKey"

    fileprivate static let monsterIntroduceKey = "monsterIntroduceKey"
    
    fileprivate static let userDefaults = UserDefaults.standard

    static var animalsIsHard: Bool {
        get {
            return userDefaults.bool(forKey: animalsDifficultyKey)
        }
        set {
            userDefaults.set(newValue, forKey: animalsDifficultyKey)
        }
    }

    static var alphaviteIsHard: Bool {
        get {
            return userDefaults.bool(forKey: alphaviteDifficultyKey)
        }
        set {
            userDefaults.set(newValue, forKey: alphaviteDifficultyKey)
        }
    }

    static var colorsIsHard: Bool {
        get {
            return userDefaults.bool(forKey: colorsDifficultyKey)
        }
        set {
            userDefaults.set(newValue, forKey: colorsDifficultyKey)
        }
    }

    static var lastRateVersion: String? {
        get {
            return userDefaults.string(forKey: rateVersionKey)
        }
        set {
            userDefaults.set(newValue, forKey: rateVersionKey)
        }
    }

    // in current version
    static var appOpenedCount: Int {
        get {
            return userDefaults.integer(forKey: appOpenedCoundKey)
        }
        set {
            userDefaults.set(newValue, forKey: appOpenedCoundKey)
        }
    }

    static var alphabetTip: Int {
        get {
            return userDefaults.integer(forKey: "alphabetTip")
        }
        set {
            userDefaults.set(newValue, forKey: "alphabetTip")
        }
    }

    static var onBoarding: Bool {
        get {
            return userDefaults.bool(forKey: "onBoarding")
        }
        set {
            userDefaults.set(newValue, forKey: "onBoarding")
        }
    }

    static var animalsTip: Int {
        get {
            return userDefaults.integer(forKey: "animalsTip")
        }
        set {
            userDefaults.set(newValue, forKey: "animalsTip")
        }
    }
    
    static var monsterTip: Int {
        get {
            return userDefaults.integer(forKey: "monsterTip")
        }
        set {
            userDefaults.set(newValue, forKey: "monsterTip")
        }
    }

    static var monsterFreeGames: Int {
        get {
            return userDefaults.integer(forKey: "monsterFreeGames")
        }
        set {
            userDefaults.set(newValue, forKey: "monsterFreeGames")
        }
    }
    
    static var analiticsLastSend: Double {
        get {
            return userDefaults.double(forKey: analiticsKey)
        }
        set {
            userDefaults.set(newValue, forKey: analiticsKey)
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
            return false
        }
        else{
            return true
        }
    }

    static func setfirstLaunch(){
        userDefaults.set(true, forKey: firstLaunchKey)
    }
    
    static func logout() {
        userDefaults.removeObject(forKey: accessTokenKey)
        //userDefaults.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
    }

    // MARK: Introduce Video
    static var firstAnimalsIntroduce: Bool {
        get {
            return userDefaults.bool(forKey: animalFirstIntroduce)
        }
        set {
            userDefaults.set(newValue, forKey: animalFirstIntroduce)
        }
    }
    static var secondAnimalsIntroduce: Bool {
        get {
            return userDefaults.bool(forKey: animalSecondIntroduce)
        }
        set {
            userDefaults.set(newValue, forKey: animalSecondIntroduce)
        }
    }

    static var alphaviteIntroduce: Bool {
        get {
            return userDefaults.bool(forKey: alphaviteIntroduceKey)
        }
        set {
            userDefaults.set(newValue, forKey: alphaviteIntroduceKey)
        }
    }
    
    static var monsterIntroduce: Bool {
        get {
            return userDefaults.bool(forKey: monsterIntroduceKey)
        }
        set {
            userDefaults.set(newValue, forKey: monsterIntroduceKey)
        }
    }
    static var colorsGameIntroduce: Bool {
        get {
            return userDefaults.bool(forKey: colorsGameIntroduceKey)
        }
        set {
            userDefaults.set(newValue, forKey: colorsGameIntroduceKey)
        }
    }
}
