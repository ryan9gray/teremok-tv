//
//  GUDateError.swift
//  gu
//
//  Created by NRokudaime on 06.12.2017.
//  Copyright © 2017 altarix. All rights reserved.
//

import Foundation

enum DateError: Error, LocalizedError {
    case parseException
    
    var errorDescription: String? {
        switch self {
        case .parseException:
            return "Неверный формат"
        }
    }
}
