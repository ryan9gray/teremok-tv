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
	@IBOutlet private var hourseView: PromoTimeView!
	@IBOutlet private var minuteView: PromoTimeView!
	@IBOutlet private var labels: [UILabel]!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		restoreButton.text = "Восстановить подписку"
		purchaseButton.gradientColors = Style.Gradients.yellow.value
		labels.forEach { $0.textColor = UIColor.Label.titleText }
		titleLabel.textColor = UIColor.Label.titleText
		priceLabel.textColor = UIColor.Label.red
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

	func setTimer() {
		let time = PromoWorker.getCurrentDate
		hourseView.set(time: time.hour().stringValue, title: "часов")
		minuteView.set(time: time.minute().stringValue, title: "минут")
	}

	func configurate(sub: RegisteredPurchase, input: Input, have: Bool = false) {
		self.input = input
		subscription = sub
		switch sub {
			case .promo3month:
				titleLabel.text = "Интеллектум на 3 месяца"
			default: break
		}
		priceLabel.isHidden = have
		restoreButton.isHidden = have
		if have {
			purchaseButton.gradientColors = Style.Gradients.green.value
			purchaseButton.setTitle("Оформлена", for: .normal)
			purchaseButton.setTitleColor(.white, for: .normal)
		} else {
			purchaseButton.gradientColors = Style.Gradients.yellow.value
			purchaseButton.setTitle("Оформить", for: .normal)
			purchaseButton.setTitleColor(UIColor.Label.titleText, for: .normal)

		}
		input.updatePrice(subscription) { [weak self] price in
			self?.priceLabel.text = "\(price) / 3 мес"
		}
	}
}
