//
//  SubscriptionPromoTableViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 26.12.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class SubscriptionPromoCollectionViewCell: UICollectionViewCell {
	@IBOutlet private var restoreButton: UnderlinedLabel!
	@IBOutlet private var purchaseButton: UIRoundedButtonWithGradientAndShadow!
	@IBOutlet private var priceLabel: UILabel!
	@IBOutlet private var titleLabel: UILabel!

	@IBOutlet private var downloadView: UIView!
	@IBOutlet private var heartView: UIView!
	@IBOutlet private var musicView: UIView!
	@IBOutlet private var gameView: UIView!

	@IBOutlet private var labels: [UILabel]!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		restoreButton.text = "Восстановить подписку"
		purchaseButton.gradientColors = Style.Gradients.yellow.value
		labels.forEach { $0.textColor = UIColor.Label.titleText }
		titleLabel.textColor = UIColor.Label.titleText
		priceLabel.textColor = UIColor.Label.titleText
	}

	@IBAction private func purchaseTap(_ sender: Any) {
		output.purchaseAction()
	}
	@IBAction private func restoreTap(_ sender: Any) {
		output.restoreAction()
	}

	var output: Output!
	var input: Input!
	var subscription: RegisteredPurchase!

	struct Input {
		var updatePrice: (_ sub: RegisteredPurchase, _ completion: @escaping (String) -> Void) -> Void
	}

	struct Output {
		let restoreAction: () -> Void
		let purchaseAction: () -> Void
	}
	
}
