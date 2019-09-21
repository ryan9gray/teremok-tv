//
//  AppDelegate.swift
//  Teremok-TV
//
//  Created by R9G on 03.08.2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SwiftyStoreKit
import Trackable
import Firebase
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, TrackableClass {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureApp()
        configureUserNotifications(application, launchNotification: launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification])

        //var keychainService: KeychainService = MainKeychainService()
        //keychainService.saveAuthSession(session: "93737380f2c22f6ca0599f46771f0bfa160d27083d1a63b70055e8d4a79e836e")

        if LocalStore.lastRateVersion != AppInfoWorker.applicationShortVersion {
            LocalStore.appOpenedCount += 1
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        track(Events.App.didEnterBackground)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        track(Events.App.didBecomeActive)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        track(Events.App.terminated)
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        BackgroundSession.shared.saveBackgroundCompletionHandler(completionHandler)
    }
    
    fileprivate func configureApp() {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])

        let onDemandLoader = OnDemandLoader()
        onDemandLoader.loadOnDemandAssets()
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        configureAppearance()
        configureAppLaunchesInfo()
        completeIAPTransactions()
        updateTokenIfNeeded()
        configureAuthMigration()
        setupTrackableChain(parent: analytics)
    }

    private func completeIAPTransactions() {
        SwiftyStoreKit.completeTransactions(atomically: true) { products in
            for product in products {
                if product.transaction.transactionState == .purchased || product.transaction.transactionState == .restored {
                    if product.needsFinishTransaction {
                        // Deliver content from server, then:
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                    print("purchased: \(product)")
                }
            }
        }
    }
    
    private func configureAppLaunchesInfo() {
        var launchInfoDefaults = AppLaunchInfoDefaults.fromDefaults()
        if launchInfoDefaults.appVersion != AppInfoWorker.applicationVersion() {
            launchInfoDefaults = AppLaunchInfoDefaults()
            analytics.updatedEvent()
        }
        if launchInfoDefaults.launchesCount == 0 {
            launchInfoDefaults.firstAppLaunchDate = Date()
        }
        launchInfoDefaults.launchesCount += 1
        launchInfoDefaults.saveToDefaults()
    }

    fileprivate func configureAppearance() {
        //UITextField.appearance().tintColor = UIColor.TextField.text
        //UILabel.appearance().textColor = BackgroundMediaWorker.isNigh() ? UIColor.View.orange : UIColor.View.titleText
    }

    fileprivate func updateTokenIfNeeded() {
        let keychain: KeychainService = MainKeychainService()
        let currentToken = ServiceConfiguration.activeConfiguration().token
        if keychain.lastRequestToken != currentToken {
            keychain.saveLastRequestToken(token: currentToken)
            updateCloudTokenOnService()
        }
    }
    
    fileprivate func configureAuthMigration() {
        let migrationDefaults = MigrationDefaults()
        
        if migrationDefaults.firstLaunch {
            //Сброс сессии при первом запуске
            let keychain: KeychainService = MainKeychainService()
            keychain.resetAuthSession()
            keychain.resetPhoneSession()
            // Обновление последнего используемого токена
            let currentToken = ServiceConfiguration.activeConfiguration().token
            keychain.saveLastRequestToken(token: currentToken)
            //Попытка подтянуть сессию из старой версии приложения
            if !migrationDefaults.sessionKeeped {
                let sessionKey = "sessionId"
                let tokenKey = "deviceToken"
                if let oldSession = UserDefaults.standard.string(forKey: sessionKey) {
                    let keychain: KeychainService = MainKeychainService()
                    keychain.saveAuthSession(session: oldSession)
                    UserDefaults.standard.setValue("", forKey: sessionKey)
                    UserDefaults.standard.synchronize()
                }
                
                // Попытка подтянуть старый облачный токен
                if let oldCloudToken = UserDefaults.standard.string(forKey: tokenKey) {
                    UserDefaults.standard.set(oldCloudToken, forKey: "pushToken")
                    UserDefaults.standard.synchronize()
                    updateCloudTokenOnService()
                }
                migrationDefaults.sessionKeeped = true
            }
            migrationDefaults.firstLaunch = false
        }
    }
}
