//
//  CacheableCommand.swift
//  RZD
//
//  Created by Mikhail Tishin on 15/01/2017.
//  Copyright © 2017 tt. All rights reserved.
//

import SwiftyJSON

struct CacheExpiration {
    static let week        = TimeInterval(60 * 60 * 24 * 7)
    static let day         = TimeInterval(60 * 60 * 24)
    static let hour        = TimeInterval(60 * 60)
    static let halfAnHour  = TimeInterval(60 * 30)
    static let fiveMinutes = TimeInterval(60 * 5)
}
protocol Cacheable {
    
    var uniqueCacheIdentifier: String { get }
    
}

class CacheableCommand: BasicCommand {

    var shouldUseCache: Bool = false
    var shouldSaveToCache: Bool {
        return true
    }
    var expirationInterval: TimeInterval = CacheExpiration.hour
    private(set) var serverExpiryInterval: TimeInterval?
    var shoudRemoveCach: Bool = true

    /// Remove all cache for current command
    static func removeCache() {
        AppCacher.expirable.removeValues(forCategory: String(describing: self))
    }

    func cachedResponse() -> ApiResponse? {
        if shouldUseCache,
            let jsonString = AppCacher.expirable.getValue(forId: uniqueCacheIdentifier, shoudDelete: shoudRemoveCach),
            let url = URL(string: fullRequestString),
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil) {
            return ApiResponse(response: response, data: jsonString.data(using: .utf8), error: nil)
        } else {
            if shoudRemoveCach {
                removeCache()
            }
            return nil
        }
    }
    func cachedForceResponse() -> ApiResponse? {
        if let jsonString = AppCacher.expirable.getForceValue(forId: uniqueCacheIdentifier),
            let url = URL(string: fullRequestString),
            let response = HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil) {
            return ApiResponse(response: response, data: jsonString.data(using: .utf8), error: nil)
        } else {
            return nil
        }
    }
    func saveJsonToCache(fullJson: JSON) {
        let expiryInterval = serverExpiryInterval ?? expirationInterval
        AppCacher.expirable.saveValue(
            forId: uniqueCacheIdentifier,
            value: fullJson.description,
            expiration: Date(timeIntervalSinceNow: expiryInterval),
            category: String(describing: type(of: self))
        )
    }

    /// Remove cache for current request
    func removeCache() {
        AppCacher.expirable.removeValue(forId: uniqueCacheIdentifier)
    }

    // MARK: - BasicCommand

    override func request(responseHandler: @escaping (ApiResponse) -> Void, failure: ApiCompletionBlock?) {

        if let cachedResponse = cachedResponse() {
            responseHandler(cachedResponse)
        } else {
            super.request(responseHandler: { (response) in
                if let interval = response.fullJson["cacheTime"].int {
                    self.serverExpiryInterval = TimeInterval(interval)
                }
                if self.shouldSaveToCache {
                    self.saveJsonToCache(fullJson: response.fullJson)
                }
                responseHandler(response)
            }) { (cmd, resp) in
                if let cachedResponse = self.cachedForceResponse() {
                    responseHandler(cachedResponse)
                }
                else {
                    failure?(cmd, resp)
                }
            }
        }
    }
}

// MARK: - Cacheable
extension CacheableCommand: Cacheable {

    func getJoinedDictionaryString(parameters: [String: Any]) -> String {
        var parametersString: String = ""
        for (key, value) in parameters {
            var valueString: String? = nil
            if let value = value as? String {
                valueString = key + value
            } else if let value = value as? Int {
                valueString = key + String(value)
            } else if let value = value as? [String] {
                valueString = value.compactMap({ $0 }).joined()
            } else if let value = value as? Bool {
                valueString = key + (value ? "true" : "false")
            }

            if let valueString = valueString {
                parametersString += valueString
            }
        }
        return parametersString
    }

    var uniqueCacheIdentifier: String {
        var parametersString: String = fullRequestString
        parametersString += getJoinedDictionaryString(parameters: parameters)
        for (_, value) in parameters {
            var valueString: String? = nil
            if let value = value as? [String: Any] {
                valueString = getJoinedDictionaryString(parameters: value)
            } else if let value = value as? [[String: Any]] {
                var dictsString = ""
                value.forEach({(dict) in
                    dictsString += getJoinedDictionaryString(parameters: dict)
                })
                if !dictsString.isEmpty {
                    valueString = dictsString
                }
            }

            if let valueString = valueString {
                parametersString += valueString
            }
        }
        if !parameters.isEmpty {
            return fullRequestString + "." + parametersString.md5()
        }

        return fullRequestString
    }

}
