//
//  ReachabilityManager.swift
//  Teremok-TV
//
//  Created by R9G on 25/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import Alamofire


class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.listener = { status in
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
                    if !NetworkManager.isConnectedToInternet {
                        NotificationCenter.default.post(name: .Internet, object: true, userInfo: nil)
                    }
                })
                return
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                
            }
            NotificationCenter.default.post(name: .Internet, object: false, userInfo: nil)
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
    
    class var isConnectedToInternet: Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    class var isConnectedToWifi: Bool {
        return NetworkReachabilityManager()!.isReachableOnEthernetOrWiFi
    }
}
