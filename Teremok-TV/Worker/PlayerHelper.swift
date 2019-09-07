//
//  PlayerHelper.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/04/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import AVFoundation

struct PlayerHelper {
    static func stringFromTimeInterval(_ seconds: TimeInterval) -> String {
        if seconds.isNaN{
            return "00:00"
        }
        let interval = Int(seconds)
        let sec = Int(seconds.truncatingRemainder(dividingBy: 60))
        let min = interval / 60
        return String(format: "%02d:%02d", min, sec)
    }
}
