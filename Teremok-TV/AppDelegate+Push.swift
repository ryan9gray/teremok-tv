//
//  AppDelegate+Push.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

import Foundation
import ObjectMapper
import UserNotifications

extension AppDelegate {

    func configureUserNotifications(_ application: UIApplication, launchNotification: Any?) {
        //
        
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
            if let er = error{
                let log = "requestAuthorization error \(er)"
                print(log)
                //GULogService.appendLog(with: log)
            }
            if granted {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        }
    }
    
    @discardableResult func application(_ application: UIApplication, handlePush push: TTPush) -> Bool {
        switch push.action {
        case .web(let link):
            if application.canOpenURL(link) {
                let service: URLServices = URLMainServices()
                return service.open(url: link)
            }
            break
        default:
            if let controller = UIApplication.topCommonRouterLogicController() as? PushRoutable  {
                if controller.handle(push: push){
                    return true
                }
            }
            if let rootViewController = window?.rootViewController as? PushRoutable {
                return rootViewController.handle(push: push)
            }
        }
        return false
    }
    
    func application(_ application: UIApplication, shouldShowAlertForPush push: TTPush) -> Bool {
        return application.applicationState == .active
    }
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let oldToken = AppInfoWorker.pushToken()
        AppInfoWorker.updateCloudToken(deviceToken)
        let newToken = AppInfoWorker.pushToken()
        if oldToken != newToken {
            updateCloudTokenOnService()
        }
        print("Push token: \(AppInfoWorker.pushToken() ?? "")")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        AppInfoWorker.updateCloudToken(nil)
        updateCloudTokenOnService()
        print(error)
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        NSLog("[PUSH-DEBUG] \(userInfo)")
        self.didReceiveRemoteNotification(application, userInfo: userInfo)
    }
    
    func didReceiveRemoteNotification(_ application: UIApplication, userInfo: [AnyHashable: Any]) {
        if let push = Mapper<TTPush>().map(JSONObject: userInfo) {
            
            //RequestCacheCleaner.clearWidgetsCache(with: push)

            if self.application(application, shouldShowAlertForPush: push) {
                
                var title: String?
                var message: String?
                
                switch push.aps.alert {
                    case .string(let alert):
                        message = alert
                    case .object(let alert):
                        title = alert.title
                        message = alert.body
                    default:
                        break
                }
                switch push.action {
                    case .achieve:
                        NotificationCenter.default.post(name: .AchievmentBadge, object: nil, userInfo: ["Ach": push.aps.badge])
                    case .newVideo:
                        break
                    default:
                        break
                }
            
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Просмотр", style: .default, handler: { (_) in
                    let delegate = UIApplication.shared.delegate as? AppDelegate
                    delegate?.application(application, handlePush: push)
                }))
                alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                
                var presenter = window?.rootViewController
                while presenter?.presentedViewController != nil {
                    presenter = presenter?.presentedViewController
                }
                if let currentController = UIApplication.topViewController() as? PushRoutable {
                    currentController.alertPresentedFor(push: push)
                }
                presenter?.present(alert, animated: true, completion: nil)
            } else {
                self.application(application, handlePush: push)
            }
        } else {
            let log = "Can't decode push: \(userInfo)"
            print(log)
            //LogService.appendLog(with: log)
        }
        NotificationCenter.default.post(name: .BadgeDidRecivePush, object: nil)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void) {
        
        let state = UIApplication.shared.applicationState
        if state == .active {

            self.didReceiveRemoteNotification(application, userInfo: userInfo)
        } else {

        }
        completionHandler(.newData)
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        self.didReceiveRemoteNotification(UIApplication.shared, userInfo: userInfo)
        
    }
    
}

