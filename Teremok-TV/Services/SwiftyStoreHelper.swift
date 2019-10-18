//
//  SwiftyStoreHelper.swift
//  GeekTV
//
//  Created by Ryan9Gray on 22.02.17.
//  Copyright © 2017 DoubleDevTeam. All rights reserved.
//
import StoreKit
import SwiftyStoreKit

enum RegisteredPurchase : String, CaseIterable {
    case game = "fullSubs"
    case music = "VandM"
    case video = "month"

    var premium: Premium {
        switch self {
        case .game:
            return .game
        case .music:
            return .music
        case .video:
            return .offline
        }
    }
}

protocol SwiftyStorePorotocol {
    func buy(product: RegisteredPurchase, completion: @escaping (Result<PurchaseDetails>) -> Void)
    func info(product: RegisteredPurchase, completion: @escaping (_ price: String) -> Void)
    func restoreSub(completion: @escaping (Result<Purchase>) -> Void)
    
}

class SwiftyStoreHelper: NSObject, SwiftyStorePorotocol {
    let AppBundleId = "ru.xmedia.teremoktv"
    //var sharedSecret = "919a706ee42143df8571a316f14531c8"

    let videoPurchase = RegisteredPurchase.video
    
    func buy(product: RegisteredPurchase, completion: @escaping (Result<PurchaseDetails>) -> Void){
        SwiftyStoreKit.purchaseProduct(product.rawValue, atomically: false) { result in
            switch result {
            case .success(let product):
                // fetch content from your server, then:

                completion(.success(product))

//                if product.needsFinishTransaction {
//                    SwiftyStoreKit.finishTransaction(product.transaction)
//                }
                print("Purchase Success: \(product.productId)")

            case .error(let error):
                completion(.failure(error))
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                default: print("Unknown error. Please contact support")
                }
            }
        }
    }
    
    func restoreSub(completion: @escaping (Result<Purchase>) -> Void){
        
        SwiftyStoreKit.restorePurchases(atomically: false) { results in
            if results.restoredPurchases.count > 0 {
                for product in results.restoredPurchases {
                    if product.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(product.transaction)
                    }
                }
                if let purchase = results.restoredPurchases.last{
                    completion(.success(purchase))
                    return
                }
                print("Restore Success: \(results.restoredPurchases)")
            }
            else {
                print("Nothing to Restore")
            }
            completion(.failure(BackendError.objectSerialization(reason: "Не удалось восстановить покупки")))
        }
    }

    func verifySub(){
        let appleValidator = AppleReceiptValidator(service: .production)
        SwiftyStoreKit.verifyReceipt(using: appleValidator) { (result) in
            switch result {
            case .success(let receipt):
                // Verify the purchase of a Subscription
                let purchaseResult = SwiftyStoreKit.verifySubscription(ofType: .autoRenewable, productId: self.videoPurchase.rawValue, inReceipt: receipt)
                
                switch purchaseResult {
                case .purchased(let expiresDate, _):
                    print("Product is valid until \(expiresDate)")
                    self.premiumDate(dat: expiresDate)
                case .expired(let expiresDate):
                    print("Product is expired since \(expiresDate)")
                case .notPurchased:
                    print("The user has never purchased this product")
                }
                
            case .error(let error):
                print("Receipt verification failed: \(error)")
            }
        }
    }
    
    
    func premiumDate(dat: Date){
        let interval = dat.timeIntervalSince1970 - Date().timeIntervalSince1970
        if interval > 0 {
            self.alertTimeInterval(interval: interval)
        }
        print("\(interval)")
    }
    
    func alertTimeInterval(interval: TimeInterval) {
        let ti = CLong(interval)
        let days = ti / 86400
        print("days \(days)")
        //ErrorCenter.mesaga(error: String(format: "Срок действия подписки %0.2d дн ", days))
    }
    
    func validateRestoreReceipt(transactionIdentifier: String, completion: @escaping (_ status : Bool) -> Void)  {

        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = receiptData?.base64EncodedString(options: [])
        
        let dict = ["receipt-data" : receiptString!, "product_id":"GTVFirstMonthSub", "transactionIdentifier":transactionIdentifier]
        
        print("\(dict)")
    }
    
    func validateReceipt(transactionIdentifier : String, completion : @escaping (_ status : Bool) -> Void)  {

        let receiptData = SwiftyStoreKit.localReceiptData
        let receiptString = receiptData?.base64EncodedString(options: [])
        
        let dict = ["receipt-data" : receiptString!, "product_id":"GTVFirstMonthSub", "transactionIdentifier":transactionIdentifier]

        print("\(dict)")
    }

    func info(product: RegisteredPurchase, completion: @escaping (_ price: String) -> Void) {
        SwiftyStoreKit.retrieveProductsInfo([product.rawValue]) { result in
            if let product = result.retrievedProducts.first {
                let priceString = product.localizedPrice!
                completion(priceString)
                print("Product: \(product.localizedDescription), price: \(priceString)")
            }
            else if let invalidProductId = result.invalidProductIDs.first {
                return print("Invalid product identifier: \(invalidProductId)")
            }
            else {
                print("Error: \(result.error!)")
            }
        }
    }
}

