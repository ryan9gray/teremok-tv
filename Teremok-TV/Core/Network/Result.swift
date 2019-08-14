//
//  Result.swift
//  vapteke
//
//  Created by R9G on 27.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import Foundation


enum Result<Value> {
    
    case success(Value)
    case failure(Error)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
    
    var value: Value? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: Error? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
