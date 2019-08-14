//
//  BackgroundSoundWorker.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22/01/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

struct BackgroundMediaWorker {

    static var hour: Int {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        print("hour \(hour)")
        return hour
    }

    //оптимизайция - считать час один раз
    private static var hourLocal: Int = 0

    static func setImage(background: UIImageView){
        hourLocal = hour
        switch hourLocal {
        case 0...6, 21...:
            background.image = #imageLiteral(resourceName: "ic-background_night")
             UILabel.appearance().textColor = UIColor.View.orange
        case 17...21:
            background.image = #imageLiteral(resourceName: "ic-background_evening")
            UILabel.appearance().textColor = UIColor.View.titleText
        default:
            background.image = #imageLiteral(resourceName: "ic-hillBackground")
            UILabel.appearance().textColor = UIColor.View.titleText
        }
       //background.image = #imageLiteral(resourceName: "ic-background_night")
    }

    static func setText(){
        hourLocal = hour
        switch hourLocal {
        case 0...6, 21...:
            UILabel.appearance().textColor = UIColor.View.orange
        case 17...21:
            UILabel.appearance().textColor = UIColor.View.titleText
        default:
            UILabel.appearance().textColor = UIColor.View.titleText
        }
    }

    static func getSound()-> URL {
        if 0...6 ~= hourLocal || hourLocal > 20 {
            return URL(fileURLWithPath: Bundle.main.path(forResource: "night_sound", ofType: "wav")!)
        }
        else {
            return URL(fileURLWithPath: Bundle.main.path(forResource: "day_sound", ofType: "mp3")!)
        }
    }

}
