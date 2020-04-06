

import UIKit
import CoreText

extension UIColor {

	enum Base {
		static let yellow                   = UIColor(hex: "FFD86B")
		static let darkBlue                 = UIColor(hex: "2E334D")

	}
    // Palette
    enum Button {
        static let beige                        = UIColor(hex: "FFF1CC")
        static let yellowOne                    = UIColor(hex: "FFD632")
        static let yellowTwo                    = UIColor(hex: "FFBD14")
		static let titleText                    = Label.titleText
        static let red                          = UIColor(hex: "E33A3A")
        static let lightGray                    = UIColor(hex: "E2E2E2")
		static let redOne                    	= UIColor(hex: "FF5F7C")
		static let redTwo                    	= UIColor(hex: "E33A3A")
    }
    enum Label {
        static let titleText            =  UIColor(hex: "2E334D")
        static let orange               =  #colorLiteral(red: 0.9921568627, green: 0.431372549, blue: 0.2980392157, alpha: 1)   //FD6E4C
        static let peach                = UIColor(hex: "E33A3A")
        static let darkBlue             = UIColor(hex: "0058BA")
        static let yellow               = UIColor(hex: "DDFF00")
        static let gray                 =  #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)   //999999
        static let grass                =  #colorLiteral(red: 0.1333333333, green: 0.6431372549, blue: 0.4, alpha: 1)   //22A466
        static let ocean                =  #colorLiteral(red: 0.1647058824, green: 0.8117647059, blue: 0.9960784314, alpha: 1)   //2ACFFE
        static let red                    = UIColor(hex: "E74C1E")
        static let darkRed              = UIColor(hex: "841717")
        static let redPromo             = UIColor(hex: "F15A48")
    }

    enum View {
        static let green                    =  #colorLiteral(red: 0.5960784314, green: 0.8117647059, blue: 0.3490196078, alpha: 1)   //98CF59
        static let orange                   =  #colorLiteral(red: 1, green: 0.6039215686, blue: 0, alpha: 1)   //FF9A00
        static let yellowBase               =  #colorLiteral(red: 1, green: 0.8705882353, blue: 0.4941176471, alpha: 1)   //FFDE7E

        enum Alert {
            static let textColor            = #colorLiteral(red: 0.2366027236, green: 0.2647619247, blue: 0.3750775456, alpha: 1)   // 333333
        }
    }

    enum Cell {
        static let highlighted                  = #colorLiteral(red: 0.5764705882, green: 0.5450980392, blue: 0.5450980392, alpha: 1).withAlphaComponent(0.05)  // 938B8B
        static let separator                    = #colorLiteral(red: 0.5764705882, green: 0.5450980392, blue: 0.5450980392, alpha: 1).withAlphaComponent(0.1)   // 938B8B
    }
    enum ColorsGame {
        static let purp                             = UIColor(hex: "634BF4")

        static let orangeOne                        = UIColor(hex: "FFAF37")
        static let orangeTwo                        = UIColor(hex: "FF6737")

        static let violetOne                        = UIColor(hex: "E57CFF")
        static let violetTwo                        = UIColor(hex: "634BF4")

        static let greenOne                         = UIColor(hex: "C2EB1C")
        static let greenTwo                         = UIColor(hex: "2C8800")

        static let redOne                           = UIColor(hex: "FF6535")
        static let redTwo                           = UIColor(hex: "FF0F0F")

        static let blueOne                          = UIColor(hex: "4FA4F3")
        static let blueTwo                          = UIColor(hex: "02499D")
        
        static let lightBlueOne                     = UIColor(hex: "00FFF0")
        static let lightBlueTwo                     = UIColor(hex: "00A3FF")

        static let yellowOne                        = UIColor(hex: "FFF62B")
        static let yellowTwo                        = UIColor(hex: "FFBF2B")

        static let brownOne                         = UIColor(hex: "CA6807")
        static let brownTwo                         = UIColor(hex: "733B03")
    }

    enum Alphavite {
        static let orangeOne                    = UIColor(hex: "FFC327")
        static let orangeTwo                    = UIColor(hex: "F38928")

        static let violetOne                    = UIColor(hex: "7F7CFF")
        static let violetTwo                    = UIColor(hex: "4F30C9")

        static let greenOne                     = UIColor(hex: "4CD179")
        static let greenTwo                     = UIColor(hex: "1F891D")

        static let redOne                       = UIColor(hex: "FF5F7C")
        static let redTwo                       = Button.red

        static let blueOne                      = UIColor(hex: "40AFFF")
        static let blueTwo                      = UIColor(hex: "0078CF")

        static let brownOne                     = UIColor(hex: "BA5354")
        static let brownTwo                     = UIColor(hex: "894A5D")

        static let playOne                      = UIColor(hex: "FFA826")
        static let playTwo                      = UIColor(hex: "D3461A")

        static let grey                         = UIColor(hex: "808080")
    }

    enum AnimalsGame {
        static let grassOne                     = UIColor(hex: "B3DA00")
        static let grassTwo                     = UIColor(hex: "D9F018")

        static let yellowOne                        = UIColor(hex: "FFB903")
        static let yellowTwo                        = UIColor(hex: "FFDF5B")

        static let coralOne                        = UIColor(hex: "F45436")
        static let coralTwo                        = UIColor(hex: "FF8777")
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
