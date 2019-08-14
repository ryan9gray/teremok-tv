//
//  TTPush.swift
//  gu
//
//  Created by Sergey Starukhin on 10.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation

struct TTPush {
    
    struct Aps {
        struct AlertObject {
            var title: String = ""
            var body: String = ""
        }
        enum AlertType {
            case empty
            case string(String)
            case object(AlertObject)
        }
        var alert: AlertType = .empty
        var badge: Int = 0
        var sound: String = ""
    }
    var aps: Aps = Aps()
    var action: TTPushActionType = .unknown
}
