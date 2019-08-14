//
//  PushTransferRoutingLogic.swift
//  Teremok-TV
//
//  Created by R9G on 25/11/2018.
//  Copyright © 2018 xmedia. All rights reserved.
//

import UIKit

protocol PushTransferRoutingLogic {
    func passPushToNextScene(viewController: UIViewController, push: TTPush)
}

extension PushTransferRoutingLogic {
    
    var estimateTransitionDuration: Double {
        return 0.5
    }
    
    func passPushToNextScene(viewController: UIViewController, push: TTPush) {
        
        if let viewController = viewController as? PushRoutable {
            executeAfterTransition {
                viewController.handle(push: push)
            }
        }
    }
    
    func executeAfterTransition(work: @escaping @convention(block) () -> Swift.Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + estimateTransitionDuration, execute: work)
    }
}

