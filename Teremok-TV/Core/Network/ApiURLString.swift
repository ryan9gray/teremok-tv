
import Foundation
import Alamofire

struct ApiURLString: URLConvertible {
    var urlString: String
    
    func asURL() throws -> URL {
        return URL(string: urlString)!
    }
}
