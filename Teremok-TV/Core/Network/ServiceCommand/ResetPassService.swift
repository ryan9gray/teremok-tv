//
//  ResetPassService.swift
//  Teremok-TV
//
//  Created by R9G on 15/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

protocol ResetPassProtocol {
    func toReset(newPass: String, oldPass: String, completion: @escaping (Result<Bool>) -> Void)
    func toRestoreQuery(email: String,completion: @escaping (Result<Bool>) -> Void)
    func toRestore(email: String,newPass: String, code: String, completion: @escaping (Result<Bool>) -> Void)
    func toCheckCode(email: String,newPass: String, code: String, completion: @escaping (Result<Bool>) -> Void)
}

struct ResetPassService: ResetPassProtocol {
    
    func toReset(newPass: String, oldPass: String, completion: @escaping (Result<Bool>) -> Void) {
        
        ResetPassCommand(newPass: newPass, oldPass: oldPass).execute(
            completion: {
                completion(.success(true))
        },
            failure: { (_, response) in
                if let error = response.error {
                    completion(.failure(error))
                }
        })
    }
    
    func toRestoreQuery(email: String,completion: @escaping (Result<Bool>) -> Void) {

        RestorePassQueryCommand(email: email).execute(
            completion: {
                completion(.success(true))
        },
            failure: { (_, response) in
                if let error = response.error {
                    completion(.failure(error))
                }
        })
    }
    func toRestore(email: String,newPass: String, code: String, completion: @escaping (Result<Bool>) -> Void) {

        RestorePassCommand(email: email, newPass: newPass, code: code).execute(
            completion: {
                completion(.success(true))
        },
            failure: { (_, response) in
                if let error = response.error {
                    completion(.failure(error))
                }
        })
    }
    func toCheckCode(email: String,newPass: String, code: String, completion: @escaping (Result<Bool>) -> Void) {

        CheckCodeCommand(email: email, code: code).execute(
            completion: {
                completion(.success(true))
        },
            failure: { (_, response) in
                if let error = response.error {
                    completion(.failure(error))
                }
        })
    }
}
