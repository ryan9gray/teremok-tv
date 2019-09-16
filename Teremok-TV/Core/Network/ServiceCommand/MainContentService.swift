//
//  MainContentService.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

protocol MainContentProtocol {
    func getMain(completion: @escaping (Result<MainContentResponse>) -> Void)

}

struct MainContentService: MainContentProtocol {
    
    func getMain(completion: @escaping (Result<MainContentResponse>) -> Void) {
        MainContentCommand().execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
}
