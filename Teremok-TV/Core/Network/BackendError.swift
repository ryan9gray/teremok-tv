//
//  BackendError.swift
//  vapteke
//
//  Created by R9G on 23.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import Foundation

enum BackendError: Error, LocalizedError {
    case network(Error)
    case jsonSerialization(error: Error)
    case objectSerialization(reason: String)
    case unreachable(Error)
    case badUrl

    var errorDescription: String? {
        switch self {
        case .network:
            return "Сервис недоступен. Попробуйте, пожалуйста, позднее."
        case .jsonSerialization:
            return "Неверный формат входящих данных"
        case .objectSerialization:
            return "Сервис недоступен. Попробуйте, пожалуйста, позднее."
        case .unreachable(_):
            return "Нет интернет соединения."
        case .badUrl:
            return "Неверный адрес"
        }
    }
}

public enum HttpError: Error {
    case nonHttpResponse(response: URLResponse)
    case badUrl
    case error(Error)
    case status(code: Int, error: Error?)
    case serialization
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
