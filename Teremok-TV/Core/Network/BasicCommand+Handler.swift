
import ObjectMapper

extension BasicCommand {
    
    func requestObject<T: BaseMappable>(success: (((T) -> Void)?), failure: (ApiCompletionBlock?), path: String? = nil) {
        let processResponse = { (response: ApiResponse) in
            
            let json = response.jsonAtResultPath(path: path)
            if let object = Mapper<T>().map(JSONString: json.description) {
                success?(object)
            } else {
                let missingValue = path ?? "result"
                response.restError = BackendError.objectSerialization(reason: "Нет данных в \(missingValue)")
                failure?(self, response)
            }
        }
        request(responseHandler: processResponse, failure: failure)
    }
    
    func requestObjectArray<T: BaseMappable>(success: ((([T]) -> Void)?), failure: (ApiCompletionBlock?), path: String? = nil) {
        let processResponse = { (response: ApiResponse) in
            let json = response.jsonAtResultPath(path: path)
            //делать вид, что мы десереализовали его
            if json.type == .null || json.type == .bool {
                success?([])
                return
            }
            if let object = Mapper<T>().mapArray(JSONString: json.description) {
                success?(object)
            } else {
                let missingValue = path ?? "result"
                response.restError = BackendError.objectSerialization(reason: "Нет данных в \(missingValue)")
                failure?(self, response)
            }
        }
        request(responseHandler: processResponse, failure: failure)
    }
    
    func requestOperation(success: ((() -> Void)?), failure: (ApiCompletionBlock?), path: String? = nil) {
        let processResponse = { (response: ApiResponse) in
            success?()
            _ = response.jsonAtResultPath(path: path)
//            if json.bool == true {
//                success?()
//            } else {
//                failure?(self, response)
//            }
        }
        request(responseHandler: processResponse, failure: failure)
    }
    
}
