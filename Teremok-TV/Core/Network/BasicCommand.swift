
import Alamofire
import SwiftyJSON

typealias ApiCompletionBlock = (_ command: BasicCommand, _ response: ApiResponse) -> Void

class BasicCommand {
    
    var task: URLSessionTask?
    
    var retryNumber: Int = 0
    // MARK: - BasicCommand: defaults
    
    var mocked: Bool {
        return false
    }
    
    var method: String {
        fatalError("Need override method name")
    }
    
    var version: String {
        return "1.0"
    }
    
    var httpMethod: Alamofire.HTTPMethod {
        return .post
    }
    
    var urlString: URLConvertible {
        return ApiURLString(urlString: fullRequestString)
    }
    
    var fullRequestString: String {
        return baseUrlString + method
    }
    
    var baseUrlString: String {
        return "\(ServiceConfiguration.activeConfiguration().baseURLString)/v\(version)/"
    }
    
    var parameterEncoding: Alamofire.ParameterEncoding {
        switch httpMethod {
        case .get:
            return URLEncoding()
        default:
            return JSONEncoding()
        }
    }
    
    var headers: [String: String] {
        return [:]
    }
    
    var parameters: [String : Any] {
        fatalError("Need override parameters")
    }
    
    var expectData: Bool {
        return false
    }
    
    var token: String {
        return ServiceConfiguration.activeConfiguration().token
    }
    
    var useUserAgent: Bool {
        return false
    }
    
    var isLogging: Bool {
        return ServiceConfiguration.activeConfiguration().logging
    }
    
    var isLoggingToFile: Bool {
        return true
    }
    
    var isSigninRequest: Bool {
        return false
    }
    
    var isErrorHandling: Bool {
        return true
    }
    
    func responseHasError(response: ApiResponse) -> Bool {
        return response.error != nil
    }
    
    // MARK: - Request construction
    
    /// Вызов запроса с массивом именованных параметров
    func request(success: ApiCompletionBlock?, failure: ApiCompletionBlock?) {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        let request = getRequestWithParameters(parameters: parameters)
        var loggingData: String
        if let httpBody = request.request?.httpBody,
            let formattedData = String(data: httpBody, encoding: .utf8) {
            loggingData = formattedData
        } else {
            loggingData = String(describing: headers)
        }

        if isLogging { print(fullRequestString, loggingData) }
        
        responseForRequest(
            request: request,
            success: success,
            failure: failure
        )
    }
    
    func request(responseHandler: @escaping (ApiResponse) -> Void, failure: ApiCompletionBlock?) {
        retryNumber = 0
        request(success: { (_, response) in
            if let rid = response.resultJson["rid"].string, !rid.isEmpty {
                self.executeAsyncQuery(
                    rid: rid,
                    callStackCount: 0,
                    success: { (_, response) in
                        responseHandler(response)
                },
                    failure: failure)
            } else {
                responseHandler(response)
            }
        }, failure: failure)
    }
    
    /// Получение запроса с массивом именованных параметров
    func getRequestWithParameters(parameters: [String : Any]) -> Alamofire.DataRequest {

        // header
        let keychain: KeychainService? = {
            return MainKeychainService()
        }()
        let sessionId = keychain?.authSession ?? ""
        var mutableHeaders: [String: String] = headers
        mutableHeaders["X-Session-ID"] = sessionId
        
        if isLogging { print(mutableHeaders) }
        //
        
        //parametrs
        var mutableParameters = parameters

        if useUserAgent {
            mutableParameters["platform"] = "ios"
        }
        let deviceGuid = ServiceConfiguration.activeConfiguration().deviceID?.uuidString
        //let canPassSessionId = !(keychain?.authSession?.isEmpty ?? true)

        let bundleInfoDict = Bundle.main.infoDictionary
        let version = bundleInfoDict?["CFBundleShortVersionString"] as? String ?? ""
        let build = bundleInfoDict?["CFBundleVersion"] as? String ?? ""
        let info = ["dev_id": deviceGuid,
                    "push_token": AppInfoWorker.pushToken() ?? "",
                    "user_agent": AppInfoWorker.userAgent(),
                    "mobile": AppInfoWorker.deviceModel(),
                    "app_version": "\(version) (\(build))"]
        
        mutableParameters["api_key"] = info
		let request = BasicCommand.alamoFireManager.request(urlString,
                                                               method: httpMethod,
                                                               parameters: mutableParameters,
                                                               encoding: parameterEncoding,
                                                               headers: mutableHeaders)
        task = request.task
        return request
    }
    
    /// Формирование структуры ответа
    func responseForRequest(request: Alamofire.DataRequest, success: ApiCompletionBlock?, failure: ApiCompletionBlock?) {
        let responseHandler = { (dataResponse: DefaultDataResponse) -> Void in
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            let apiResponse = ApiResponse(
                response: dataResponse.response,
                data: dataResponse.data,
                error: dataResponse.error
            )
            if let responseString = apiResponse.responseString {
    
                if self.isLogging { print(responseString) }
            }
            

            if self.responseHasError(response: apiResponse) && !self.expectData && self.isSigninRequest {
                DispatchQueue.main.async {
                    failure?(self, apiResponse)
                }
            } else if self.responseHasError(response: apiResponse) && !self.expectData {
                if !(apiResponse.hasErrorWithSpecificHandle && self is AuthCommand) {
                    if self.isErrorHandling {
                        ErrorHandler.handleApiError(apiResponse)
                    }
                }
                DispatchQueue.main.async {
                    failure?(self, apiResponse)
                }
            } else {
                DispatchQueue.main.async {
                    success?(self, apiResponse)
                }
            }
        }
        
        if mocked {
            let mockName = String(describing: self).components(separatedBy: ".").last?.replacingOccurrences(of: "Command", with: "")
            if let url = Bundle.main.url(forResource: mockName, withExtension: "json"),
                let jsonData = try? Data(contentsOf: url) {
                
                let mockedResponse = HTTPURLResponse(
                    url: request.request!.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                    )!
                let mockedDefaultResponseData = DefaultDataResponse(
                    request: request.request,
                    response: mockedResponse,
                    data: jsonData,
                    error: nil)
                DispatchQueue.main.async {
                    responseHandler(mockedDefaultResponseData)
                }
                return
            }
        }
        
        request.response(queue: DispatchQueue.global(), completionHandler: responseHandler)
    }
    
    /// Вызов асихнронного запроса
    func executeAsyncQuery(rid: String, callStackCount: Int, success: ApiCompletionBlock?, failure: ApiCompletionBlock?) {
        let delayInterval = 0.5 * Double(NSEC_PER_SEC) * max(Double(callStackCount), 1)
        let delayTime = DispatchTime.now() + Double(Int64(delayInterval)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            var paramsWithRid = self.parameters
            paramsWithRid["rid"] = rid
            let request = self.getRequestWithParameters(parameters: paramsWithRid)
            self.responseForRequest(
                request: request,
                success: { (_, response) in
                    if callStackCount > 10 {
                        let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Сервис недоступен. Попробуйте, пожалуйста, позднее."])
                        response.restError = BackendError.network(error)
                        DispatchQueue.main.async {
                            failure?(self, response)
                        }
                    } else {
                        if let newRid = response.resultJson["rid"].string, !newRid.isEmpty {
                            self.executeAsyncQuery(
                                rid: newRid,
                                callStackCount: callStackCount + 1,
                                success: success,
                                failure: failure
                            )
                        } else {
                            DispatchQueue.main.async {
                                success?(self, response)
                            }
                        }
                    }
            },
                failure: failure
            )
        }
    }

}
extension BasicCommand {
	private static var alamoFireManager: SessionManager = {
		let configuration = URLSessionConfiguration.default
		configuration.timeoutIntervalForRequest = 10
		configuration.timeoutIntervalForResource = 10
		let alamoFireManager = Alamofire.SessionManager(configuration: configuration)
		return alamoFireManager
	}()
}
