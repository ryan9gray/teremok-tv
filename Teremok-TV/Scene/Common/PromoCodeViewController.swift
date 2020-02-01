//
//  PromoCodeViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 01.02.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
class PromoCodeViewController: UIViewController {
	var action: (() -> Void)?
	@IBOutlet private var labels: [UILabel]!

	@IBAction func choseClick(_ sender: Any) {
		dismiss(animated: true) {
			self.action?()
		}
	}

	@IBAction func fonClick(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		labels.forEach { $0.textColor = UIColor.Label.titleText }
	}


}
class GetPromoCodeViewController: PromoCodeViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
class SendPromoCodeViewController: PromoCodeViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}


}
class ActivatedPromoCodeViewController: PromoCodeViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}


}
class OneMorePromoCodeViewController: PromoCodeViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}


}
