//
//  ButtonCellProtocol.swift
//  Teremok-TV
//
//  Created by R9G on 06/09/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import Foundation
import UIKit

protocol ButtonCellProtocol :AnyObject {
    
    func buttonClick(_ sender: Any)
    
}


protocol SerialCellProtocol {
    
    func favClick(_ sender: Any)
    func downloadClick(_ sender: Any)

}
