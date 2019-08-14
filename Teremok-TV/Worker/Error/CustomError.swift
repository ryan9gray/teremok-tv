//
//  GUCustomError.swift
//  gu
//
//  Created by Армен Алумян on 19.03.2018.
//  Copyright © 2018 altarix. All rights reserved.
//

import Foundation

class CustomError: Error, LocalizedError {
    var errorDescription: String?
    
    init(description: String? = nil) {
        errorDescription = description
    }
}
