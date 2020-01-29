//
//  ServiceResponse.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.01.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import Foundation
import ObjectMapper

protocol ServiceResponse {
	static func decodeFromJson(json: Any?) -> Self
	static func decodeArrayFromJson(json: Any?) -> [Self]
}

extension ServiceResponse where Self: Mappable {
	//
	static func decodeFromJson(json: Any?) -> Self {
		if let object = Mapper<Self>().map(JSONObject: json) {
			return object
		}
		fatalError()
	}

	static func decodeArrayFromJson(json: Any?) -> [Self] {
		if let array = Mapper<Self>().mapArray(JSONObject: json) {
			return array
		}
		return []
	}
}
