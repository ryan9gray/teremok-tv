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

	@Storage(userDefaults: userDefaults, key: "promo6MonthTimer", defaultValue: 0)
	static var promo6MonthTimer: Int

	@Storage(userDefaults: userDefaults, key: "animalsDifficultyKey", defaultValue: false)
    static var animalsIsHard: Bool

    @Storage(userDefaults: userDefaults, key: "alphaviteDifficultyKey", defaultValue: false)
    static var alphaviteIsHard: Bool

    @Storage(userDefaults: userDefaults, key: "colorsDifficultyKey", defaultValue: false)
    static var colorsIsHard: Bool

    @Storage(userDefaults: userDefaults, key: "onBoarding", defaultValue: false)
    static var onBoarding: Bool

    @Storage(userDefaults: userDefaults, key: "rateVersion", defaultValue: "")
    static var lastRateVersion: String

    // in current version
    @Storage(userDefaults: userDefaults, key: "appOpenedCound", defaultValue: 0)
    static var appOpenedCount: Int

    @Storage(userDefaults: userDefaults, key: "monsterTip", defaultValue: 0)
    static var monsterTip: Int

    @Storage(userDefaults: userDefaults, key: "alphabetTip", defaultValue: 0)
    static var alphabetTip: Int

    @Storage(userDefaults: userDefaults, key: "animalsTip", defaultValue: 0)
    static var animalsTip: Int

    @Storage(userDefaults: userDefaults, key: "colorsGameTip", defaultValue: 0)
    static var colorsGameTip: Int

    @Storage(userDefaults: userDefaults, key: "monsterFreeGames", defaultValue: 0)
    static var monsterFreeGames: Int

    @Storage(userDefaults: userDefaults, key: "analitics", defaultValue: 0.0)
    static var analiticsLastSend: Double

    // MARK: Introduce Video
    @Storage(userDefaults: userDefaults, key: "animalFirstIntroduce", defaultValue: false)
    static var firstAnimalsIntroduce: Bool

    @Storage(userDefaults: userDefaults, key: "animalSecondIntroduce", defaultValue: false)
    static var secondAnimalsIntroduce: Bool

    @Storage(userDefaults: userDefaults, key: "alphaviteIntroduceKey", defaultValue: false)
    static var alphaviteIntroduce: Bool

    @Storage(userDefaults: userDefaults, key: "monsterIntroduceKey", defaultValue: false)
    static var monsterIntroduce: Bool

    @Storage(userDefaults: userDefaults, key: "colorsGameIntroduceKey", defaultValue: false)
    static var colorsGameIntroduce: Bool
}

@propertyWrapper
struct Storage<T> {
    private let key: String
    private let defaultValue: T
	let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard, key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
		self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }
}
