//
//  RazdelWorker.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol RazdelProtocol {
    func getSerials(razdId: Int, itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<RazdelResponse>) -> Void)
    func getCatalog(itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<RazdelResponse>) -> Void)
}

struct RazdelService: RazdelProtocol {
    
    
    func getCatalog(itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<RazdelResponse>) -> Void){
        
        CatalogCommand(itemsOnPage: itemsOnPage, shiftItem: shiftItem).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func getSerials(razdId: Int, itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<RazdelResponse>) -> Void) {
        
        let com = RazdCommand(razdId: razdId, itemsOnPage: itemsOnPage, shiftItem: shiftItem)
        com.execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
}
