//
//  UIAlertController.swift
//  gu
//
//  Created by Artem Kirillov on 04.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    open override func viewDidDisappear(_ animated: Bool) {
        let presentableController = UIApplication.topCommonRouterLogicController()
        super.viewDidDisappear(animated)
        presentableController?.modallyControllerRoutingLogic?.presentModallyNext(controller: nil,
                                                                                 from: presentableController as? UIViewController)
    }
    
    func applyStyle() {
        if let backgroundView = view.subviews.first {
            backgroundView.backgroundColor = UIColor.white
            backgroundView.layer.cornerRadius = 5
        }
        view.tintColor = UIColor.View.Alert.textColor
    }
}
