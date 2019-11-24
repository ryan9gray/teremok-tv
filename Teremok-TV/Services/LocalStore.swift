//
//  LocalStore.swift
//  Asko
//
//  Created by Ryan9Gray on 11.08.16.
//  Copyright © 2016 DoubleDevTeam. All rights reserved.
//

import UIKit


struct LocalStore {
    /// MARK: Access
    fileprivate static let firstLaunchKey = "firstLaunchKey"
    fileprivate static let analiticsKey = "analitics"
    fileprivate static let userDefaults = UserDefaults.standard

    static func firstLaunch() -> Bool {
       if userDefaults.bool(forKey: firstLaunchKey) {
           return false
       }
       else { return true }
    }

    static func setfirstLaunch() {
       userDefaults.set(true, forKey: firstLaunchKey)
    }

    static func logout() { }

    @Storage(key: "animalsDifficultyKey", defaultValue: false)
    static var animalsIsHard: Bool

    @Storage(key: "alphaviteDifficultyKey", defaultValue: false)
    static var alphaviteIsHard: Bool

    @Storage(key: "colorsDifficultyKey", defaultValue: false)
    static var colorsIsHard: Bool

    @Storage(key: "onBoarding", defaultValue: false)
    static var onBoarding: Bool

    @Storage(key: "rateVersion", defaultValue: "")
    static var lastRateVersion: String

    // in current version
    @Storage(key: "appOpenedCound", defaultValue: 0)
    static var appOpenedCount: Int

    @Storage(key: "monsterTip", defaultValue: 0)
    static var monsterTip: Int

    @Storage(key: "alphabetTip", defaultValue: 0)
    static var alphabetTip: Int

    @Storage(key: "animalsTip", defaultValue: 0)
    static var animalsTip: Int

    @Storage(key: "colorsGameTip", defaultValue: 0)
    static var colorsGameTip: Int

    @Storage(key: "monsterFreeGames", defaultValue: 0)
    static var monsterFreeGames: Int

    @Storage(key: "analitics", defaultValue: 0.0)
    static var analiticsLastSend: Double

    // MARK: Introduce Video
    @Storage(key: "animalFirstIntroduce", defaultValue: false)
    static var firstAnimalsIntroduce: Bool

    @Storage(key: "animalSecondIntroduce", defaultValue: false)
    static var secondAnimalsIntroduce: Bool

    @Storage(key: "alphaviteIntroduceKey", defaultValue: false)
    static var alphaviteIntroduce: Bool

    @Storage(key: "monsterIntroduceKey", defaultValue: false)
    static var monsterIntroduce: Bool

    @Storage(key: "colorsGameIntroduceKey", defaultValue: false)
    static var colorsGameIntroduce: Bool
}

@propertyWrapper
struct Storage<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
