//
//  AppCacher.swift
//  gu
//
//  Created by Антонов Владислав Андреевич on 10.07.17.
//  Copyright © 2017 tt. All rights reserved.
//

class AppCacher {
    
    static var mappable: MappableCacherType {
        return SqliteCacher.common
    }
    static var expirable: ExpirableCacherType {
        return SqliteCacher.common
    }
}
