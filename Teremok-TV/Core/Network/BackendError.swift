//
//  BackendError.swift
//  vapteke
//
//  Created by R9G on 23.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import Foundation

enum BackendError: Error, LocalizedError {
    case network(error: Error)
    case jsonSerialization(error: Error)
    case objectSerialization(reason: String)
    
    var errorDescription: String? {
        switch self {
        case .network:
            return "Сервис недоступен. Попробуйте, пожалуйста, позднее."
        case .jsonSerialization:
            return "Неверный формат входящих данных"
        case .objectSerialization:
            return "Сервис недоступен. Попробуйте, пожалуйста, позднее."
        }
    }
}

enum BackendInternalError: Error, LocalizedError {
    
    case wrongJSONSchema
    case `internal`(code: Int, message: String)
    
    init(with code: Int, message: String) {
        self = .internal(code: code, message: message)
    }
    
    var errorDescription: String? {
        switch self {
        case .wrongJSONSchema:
            return "Неверный формат входящих данных"
        case .internal(_, let message):
            return message
        }
    }
}

enum DownloadError: Error, LocalizedError {

    case base
    case `internal`(code: Int, message: String)

    init(with code: Int, message: String) {
        self = .internal(code: code, message: message)
    }

    var errorDescription: String? {
        switch self {
        case .base:
            return "Ошибка"
        case .internal(_, let message):
            return message
        }
    }
}
