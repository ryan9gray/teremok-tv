//
//  ColorsStartViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class ColorsStartViewController: GameViewController {

    @IBAction private func startTap(_ sender: Any) {
        buttonPlayer?.play()
        masterRouter?.startFlow(0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
