//
//  ApiURLString.swift
//  vapteke
//
//  Created by R9G on 28.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import Foundation
import Alamofire

struct ApiURLString: URLConvertible {
    var urlString: String
    
    func asURL() throws -> URL {
        return URL(string: urlString)!
    }
}
