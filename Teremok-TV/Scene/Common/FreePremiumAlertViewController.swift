//
//  FreePremiumAlertViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25.12.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring

class FreePremiumAlertViewController: UIViewController {
	@IBOutlet private var descriptionLabel: UILabel!
	@IBOutlet private var alertView: DesignableView!
	@IBOutlet private var choseButton: UIRoundedButtonWithGradientAndShadow!

	var action: (() -> Void)?

	@IBAction func choseClick(_ sender: Any) {
		dismiss(animated: true) {
			self.action?()
		}
	}

	@IBAction func fonClick(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}


	override func viewDidLoad() {
		super.viewDidLoad()

//		titleLabel.text = alert.title
//		descriptionLabel.text = alert.subtitle
//		if let buttonTitle = alert.buttonTitle {
//			doneBtn.setTitle(buttonTitle, for: .normal)
//		}
	}
	func text() {
		//if Profile.current?.need
	}

	override
	func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		alertView.layer.cornerRadius = 15
	}

	enum DescriptionText: String {
		case auth = "1"
		case notAuth = ""
	}
}
