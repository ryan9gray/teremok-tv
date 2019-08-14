//
//  RegService.swift
//  Teremok-TV
//
//  Created by R9G on 14/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation

protocol AuthProtocol {
    func toAuth(userEmail: String, userPass: String, completion: @escaping (Result<RegistrResponse>) -> Void)

}

struct AuthService: AuthProtocol {
    
    func toAuth(userEmail: String, userPass: String, completion: @escaping (Result<RegistrResponse>) -> Void) {
        
        AuthCommand(userEmail: userEmail, userPass: userPass).execute(success: { (responseObject) in
            completion(.success(responseObject))
        }) { (com, response) in
            if let error = response.error {
                completion(.failure(error))
            }
        }
    }
    


}

protocol LogoutProtocol {
    func logout()
}

struct LogoutService: LogoutProtocol {
    
    func logout(){
        LogoutCommand().execute(success: nil, failure: nil)
    }
}
