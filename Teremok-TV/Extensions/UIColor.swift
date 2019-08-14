//
//  UIColor.swift
//  vapteke
//
//  Created by R9G on 23.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import UIKit
import CoreText

extension UIColor {
    
    // Palette
        enum Button {
            static let beige                        =  #colorLiteral(red: 1, green: 0.9450980392, blue: 0.8, alpha: 1)  //FFF1CC
            static let yellowOne                    =  #colorLiteral(red: 1, green: 0.862745098, blue: 0.2509803922, alpha: 1)  //FFDC40
            static let yellowTwo                    =  #colorLiteral(red: 1, green: 0.7803921569, blue: 0.08235294118, alpha: 1)  //FFC715
            static let titleText                    = UIColor(hex: "2E334D")
            static let yellowBase                   =  #colorLiteral(red: 1, green: 0.8705882353, blue: 0.4941176471, alpha: 1)  //FFDE7E
            static let redOne                       =  #colorLiteral(red: 1, green: 0.4431372549, blue: 0.3294117647, alpha: 1)//FF7154
            static let redTwo                       =  #colorLiteral(red: 0.9019607843, green: 0.3725490196, blue: 0.1450980392, alpha: 1) //E65F25
            static let blueOne                      =  #colorLiteral(red: 0.1647058824, green: 0.8117647059, blue: 0.9960784314, alpha: 1) //2ACFFE
            static let blueTwo                      =  #colorLiteral(red: 0.4588235294, green: 0.7058823529, blue: 0.9215686275, alpha: 1)//75B4EB

        }

    enum Alphavite {

        enum Button {
            static let orangeOne                      = UIColor(hex: "FFC327")
            static let orangeTwo                      = UIColor(hex: "F38928")
            static let violetOne                      = UIColor(hex: "7F7CFF")
            static let violetTwo                      = UIColor(hex: "4F30C9")
            static let greenOne                       = UIColor(hex: "4CD179")
            static let greenTwo                      = UIColor(hex: "1F891D")
            static let redOne                      = UIColor(hex: "FF5F7C")
            static let redTwo                      = UIColor(hex: "E33A3A")
            static let blueOne                      = UIColor(hex: "40AFFF")
            static let blueTwo                      = UIColor(hex: "0078CF")
            static let brownOne                     = UIColor(hex: "BA5354")
            static let brownTwo                      = UIColor(hex: "894A5D")
            static let playOne                      = UIColor(hex: "FFA826")
            static let playTwo                      = UIColor(hex: "D3461A")
            static let grey                      = UIColor(hex: "808080")

        }
    }
 
    enum TextField {
        static let head                     = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)   // 999999
        static let placeholder              = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)   // 999999
        static let baseline                 = #colorLiteral(red: 0.8823529412, green: 0.8862745098, blue: 0.9019607843, alpha: 1)   // E1E2E6
        static let baselineActive           = #colorLiteral(red: 0.1960784314, green: 0.5607843137, blue: 0.8745098039, alpha: 1)   // 328FDF
        static let text                     = #colorLiteral(red: 0.2352941176, green: 0.2666666667, blue: 0.3764705882, alpha: 1)   //3C4460
        static let tint                     = #colorLiteral(red: 0.2156862745, green: 0.5725490196, blue: 0.8784313725, alpha: 1)   // 3792E0
    }
    
    enum View {
        static let titleText                =  #colorLiteral(red: 0.2366027236, green: 0.2647619247, blue: 0.3750775456, alpha: 1)  // 2E334D
        static let green                    =  #colorLiteral(red: 0.5958054662, green: 0.8104817271, blue: 0.3473980129, alpha: 1)
        static let orange                   =  #colorLiteral(red: 1, green: 0.6022372246, blue: 0, alpha: 1)
        static let yellow                   =  #colorLiteral(red: 1, green: 0.8700410724, blue: 0.4926636815, alpha: 1)

        enum Label {
            static let titleText                =  #colorLiteral(red: 0.2352941176, green: 0.2666666667, blue: 0.3764705882, alpha: 1)  //3C4460
            static let gray                =  #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)  //
            static let orange                =  #colorLiteral(red: 0.9905248284, green: 0.4301905036, blue: 0.2980745137, alpha: 1)
            static let grass                =  #colorLiteral(red: 0.1323567033, green: 0.6418382525, blue: 0.3993836045, alpha: 1)
            static let ocean                =  #colorLiteral(red: 0.1638697982, green: 0.8113344312, blue: 0.9947666526, alpha: 1)
        }
        
        enum Alert {
            static let textColor                = #colorLiteral(red: 0.2366027236, green: 0.2647619247, blue: 0.3750775456, alpha: 1)   // 333333
        }
    }
    
    enum Cell {
        static let highlighted                  = #colorLiteral(red: 0.5764705882, green: 0.5450980392, blue: 0.5450980392, alpha: 1).withAlphaComponent(0.05)  // 938B8B
        static let separator                    = #colorLiteral(red: 0.5764705882, green: 0.5450980392, blue: 0.5450980392, alpha: 1).withAlphaComponent(0.1)   // 938B8B
    }
    
}

extension UIColor {
    
    convenience init(withHexString hex: String, alpha: CGFloat = 1.0) {
        var hex = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") {
            hex.remove(at: hex.startIndex)
        }
        var hexInt: UInt32 = 0
        Scanner(string: hex).scanHexInt32(&hexInt)
        self.init(hex: hexInt, alpha: alpha)
    }
    
    convenience init(hex: UInt32, alpha: CGFloat = 1.0) {
        let colorComponents = (
            red: CGFloat((hex >> 16) & 0xff) / 255,
            green: CGFloat((hex >> 08) & 0xff) / 255,
            blue: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(
            red: colorComponents.red,
            green: colorComponents.green,
            blue: colorComponents.blue,
            alpha: alpha
        )
    }
    
    static func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if cString.count != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
