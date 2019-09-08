//
//  ColorsGameFlow.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class ColorsGameFlow  {
    weak var master: ColorsMasterViewController?

    init(master: ColorsMasterViewController) {
        self.master = master
        isHard = LocalStore.colorsIsHard
    }
    private var isHard: Bool = false

    func startFlow() {

    }

    deinit {
        print("Logger: ColorsFlow deinit")
    }
}
