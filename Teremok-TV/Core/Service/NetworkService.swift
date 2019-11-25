
import Foundation
import ObjectMapper

struct NetworkService {
    
    func parseArrayObjects<T: Mappable>(response: Any?, error: Error?, success: ((([T]) -> Void)?), failure: ((Error)->Void)){
        if let er = error {
            failure(er)
            return
        }
        print("\(response.debugDescription)")
        if let objects = Mapper<T>().mapArray(JSONObject: response) {
            success?(objects)
        }
        else{
            failure(BackendError.objectSerialization(reason: "Нет данных"))
        }
    }
    
    func parseObject<T: Mappable>(response: Any?, error: Error?, success: (((T) -> Void)?), failure: ((Error)->Void)){
        if let er = error {
            failure(er)
            return
        }
        print("\(response.debugDescription)")
        if let dic = response as? [String:Any] {
            if let object = Mapper<T>().map(JSONObject: dic) {
                success?(object)
            }
            else{
                failure(BackendError.objectSerialization(reason: "Нет данных"))
            }
        }
    }
    
}
