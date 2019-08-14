//
//  Int.swift
//  Teremok-TV
//
//  Created by R9G on 21/10/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

extension Int {
    var stringValue:String {
        return "\(self)"
    }
    
    
    func stringNumber() -> String {
        switch self {
        case 0: return "Ноль"
        case 1: return "Один"
        case 2: return "Два"
        case 3: return "Три"
        case 4: return "Четыре"
        case 5: return "Пять"
        case 6: return "Шесть"
        case 7: return "Семь"
        case 8: return "Восемь"
        case 9: return "Девять"
        default: return ""
        }
    }
    
}
extension CGFloat {
    /** Degrees to Radian **/
    var degrees: CGFloat {
        return self * (180.0 / .pi)
    }

    /** Radians to Degrees **/
    var radians: CGFloat {
        return self / 180.0 * .pi
    }
}
