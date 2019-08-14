//
//  SearchService.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

protocol SearchProtocol {
    func getSearch(itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<SearchResponse>) -> Void)
    func getSearch(text: String, itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<VideoResponse>) -> Void)

}
struct SearchService: SearchProtocol {
    
    func getSearch(itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<SearchResponse>) -> Void){
        
        SearchCommand(itemsOnPage: itemsOnPage, shiftItem: shiftItem).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func getSearch(text: String, itemsOnPage: Int, shiftItem: Int, completion: @escaping (Result<VideoResponse>) -> Void){

        SearchByKeywordsCommand(phrase: text, itemsOnPage: itemsOnPage, shiftItem: shiftItem).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
}
