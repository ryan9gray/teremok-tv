//
//  ChildService.swift
//  Teremok-TV
//
//  Created by R9G on 22/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

protocol ChildProtocol {
    
    func addChild(name: String, birthdate: String, sex: String,base64pic: String?, completion: @escaping (Result<AddChildResponse>) -> Void)
    func uploudAvatar(pic: String, completion: @escaping (Result<StateResponse>) -> Void)
    func deleteChild(id: String, completion: @escaping (Result<StateResponse>) -> Void)
    func editChild(id: String,name: String, birthdate: String, sex: String, completion: @escaping (Result<EditChildResponse>) -> Void)
    
}

struct ChildService: ChildProtocol {
    

    func addChild(name: String, birthdate: String, sex: String, base64pic: String?, completion: @escaping (Result<AddChildResponse>) -> Void) {
        
        AddChildCommand(childName: name, birthDate: birthdate, sex: sex, base64pic: base64pic).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func uploudAvatar(pic: String, completion: @escaping (Result<StateResponse>) -> Void) {
        
        UploadPicCommand(base64pic: pic).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func deleteChild(id: String, completion: @escaping (Result<StateResponse>) -> Void){
        
        DeleteChildCommand(id: id).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    func editChild(id: String,name: String, birthdate: String, sex: String, completion: @escaping (Result<EditChildResponse>) -> Void){
        
        EditChildCommand(childId: id, childName: name, birthDate: birthdate, sex: sex).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }

    
}
