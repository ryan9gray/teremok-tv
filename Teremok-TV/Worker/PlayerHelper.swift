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
    
    static func updateDaysText(days: Int) -> String {
        var daysText = ""
        switch days {
        case 0:
            return "сегодня"
        case 1:
            daysText = "день"
        case 2,3,4:
            daysText = "дня"
        case 5,6,7:
            daysText = "дней"
        default:
            return ""
        }
        return "через \(days) " + daysText
    }
}
