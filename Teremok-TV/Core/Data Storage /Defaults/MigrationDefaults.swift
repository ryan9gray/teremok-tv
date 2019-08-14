//
//  MigrationDefaults.swift
//  gu
//
//  Created by NRokudaime on 07.09.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation
class MigrationDefaults {
    var sessionKeeped: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "sessionKeeped")
            UserDefaults.standard.synchronize()
        }
        get {
            return UserDefaults.standard.bool(forKey: "sessionKeeped")
        }
    }
    /// Первый запуск
    var firstLaunch: Bool {
        set {
            UserDefaults.standard.set(newValue, forKey: "firstLaunch")
            UserDefaults.standard.synchronize()
        }
        get {
            if let _firstLaunch = UserDefaults.standard.value(forKey: "firstLaunch") as? Bool {
                return _firstLaunch
            }
            return true
        }
    }
}
