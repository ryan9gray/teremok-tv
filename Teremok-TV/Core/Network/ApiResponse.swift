//
//  ApiResponse.swift
//  vapteke
//
//  Created by R9G on 23.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import SwiftyJSON

class ApiResponse {
    var baseError: Error?
    var restError: BackendError?
    var jsonError: BackendInternalError?
    var resultJson: JSON!
    var fullJson: JSON!
    var data: Data?
    
    var error: Error? {
        return jsonError ?? restError ?? baseError
    }
    
    var responseString: String? {
        if fullJson != nil {
            return fullJson.rawString(.utf8, options: .prettyPrinted)
        }
        return nil
    }
    
    var hasErrorWithSpecificHandle: Bool {
        if let jsonError = jsonError {
            switch jsonError {
            case .internal(let code, _):
                return code == 401
            default:
                return false
            }
        }
        return false
        
    }
    
    var hasAuthenticationError: Bool {
        if let jsonError = jsonError {
            switch jsonError {
            case .internal(let code, _):
                return code == 114 || code == 401
            default:
                return false
            }
        }
        return false
    }
    
    var errorCode: Int? {
        if let jsonError = jsonError {
            switch jsonError {
            case .internal(let code, _):
                return code
            default:
                return nil
            }
        }
        return nil
    }
    
    func jsonAtResultPath(path: String?) -> JSON {
        if let path = path {
            return resultJson[path]
        } else {
            return fullJson
        }
    }
    
    init(response: HTTPURLResponse?, data: Data?, error: Error?) {
        if let error = error {
            if (error as NSError).code == NSURLErrorCancelled {
                baseError = NSError(domain: "NSURLErrorCancelled", code: NSURLErrorCancelled, userInfo: [NSLocalizedDescriptionKey: "Не удалось завершить операцию. Попробуйте, пожалуйста, позже."])
                return
            }
            self.baseError = error
            return
        } else {
            guard let httpResponse = response,
                let httpData = data else {
                    restError = BackendError.objectSerialization(reason: "Нет данных")
                    return
            }
            
            self.data = httpData
            if httpResponse.statusCode != 200 {
                let message = String(
                    format: "Код HTTP: %d",
                    httpResponse.statusCode
                )
                if ServiceConfiguration.activeConfiguration().logging {
                    print(message)
                }
                restError = BackendError.objectSerialization(reason: message)
            }
            
            if httpData.count > 0 {
                let json = JSON(httpData)
                if json == JSON.null, let error = json.error {
                    restError = BackendError.jsonSerialization(error: error)
                    return
                }
                
                fullJson = json
                
                if fullJson.type == .null {
                    restError = BackendError.objectSerialization(reason: "Неверный формат входящих данных")
                    return
                }
                
                resultJson = json
                
                let code = resultJson["errorCode"].string ?? ""
                let errorCode = Int(code) ?? 0 //json["errorCode"].int ?? 0 TODO://костыль
                
                
                let errorMessage = resultJson["errorMessage"].string ?? ""
                
                if errorCode != 0 {
                    jsonError = BackendInternalError.internal(code: errorCode, message: errorMessage)
                }
                
                if errorCode == 0 && errorMessage.isEmpty && resultJson.type == .null {
                    resultJson = true
                    fullJson["result"] = true
                }
            }
        }
    }
}

