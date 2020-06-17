//
//  AbstractMainViewController.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 08.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class AbstractMainViewController: AbstracViewController {
    
    func titleTopConstaraintCalculate() -> CGFloat {
        
        let constraint = UIScreen.main.bounds.height * 0.2
        return constraint >= 75.0 ? constraint : 75.0
    }
}
