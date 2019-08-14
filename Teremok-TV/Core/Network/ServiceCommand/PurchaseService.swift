//
//  PurchaseService.swift
//  Teremok-TV
//
//  Created by R9G on 10/11/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

protocol PurchaseProtocol {
    func toSubscribe(
        receipt: String,
        productId: String,
        transactionIdentifier: String,
        isRestore: Bool,
        completion: @escaping (Result<StateResponse>) -> Void
    )
    func activatePromo(code: String, completion: @escaping (Result<ActivateCodeResponse>) -> Void)
    func getPromo(completion: @escaping (Result<PromoCodeResponse>) -> Void)
}

struct PurchaseService: PurchaseProtocol {
    
    func toSubscribe(
        receipt: String,
        productId: String,
        transactionIdentifier: String,
        isRestore: Bool,
        completion: @escaping (Result<StateResponse>) -> Void
    ) {
        SubscriptionCommand(
            receiptData: receipt,
            productId: productId,
            transactionIdentifier: transactionIdentifier,
            isRestore: isRestore
        ).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    func activatePromo(code: String, completion: @escaping (Result<ActivateCodeResponse>) -> Void){
        ActivatePromoCodeCommand(promoCode: code).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    func getPromo(completion: @escaping (Result<PromoCodeResponse>) -> Void){
        GetPromoCodeCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
