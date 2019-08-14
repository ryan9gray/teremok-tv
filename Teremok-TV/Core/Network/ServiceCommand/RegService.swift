//
//  RegService.swift
//  Teremok-TV
//
//  Created by R9G on 31/08/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

protocol RegProtocol {
    func postRegistrate(childName: String, userEmail: String, userPass: String, birthDate: String, sex: String, base64pic: String?, completion: @escaping (Result<RegistrResponse>) -> Void)
    func checkEmail(email: String, completion: @escaping (Result<StateResponse>) -> Void)


}

struct RegService: RegProtocol {
    
    
    func postRegistrate(childName: String, userEmail: String, userPass: String, birthDate: String, sex: String, base64pic: String?, completion: @escaping (Result<RegistrResponse>) -> Void) {
        
        let reg = RegCommand(childName: childName, userEmail: userEmail, userPass: userPass, birthDate: birthDate, sex: sex, base64pic: base64pic)
        reg.execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    func checkEmail(email: String, completion: @escaping (Result<StateResponse>) -> Void) {
        
        CheckEmailCommand(email: email).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    
    
}
