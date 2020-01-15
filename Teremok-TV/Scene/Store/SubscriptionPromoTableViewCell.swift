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
	private var secondsView: PromoTimeView = PromoTimeView.fromNib()
	private var minuteView: PromoTimeView = PromoTimeView.fromNib()
	@IBOutlet private var labels: [UILabel]!
	@IBOutlet private var timerStackView: UIStackView!

	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
		restoreButton.text = "Восстановить подписку"
		purchaseButton.gradientColors = Style.Gradients.yellow.value
		labels.forEach { $0.textColor = UIColor.Label.titleText }
		titleLabel.textColor = UIColor.Label.titleText
		priceLabel.textColor = UIColor.Label.red

		timerStackView.subviews.forEach { $0.removeFromSuperview() }
		timerStackView.addArrangedSubview(minuteView)
		timerStackView.addArrangedSubview(secondsView)
		NSLayoutConstraint.activate([
			minuteView.widthAnchor.constraint(equalToConstant: 44.0),
			minuteView.heightAnchor.constraint(equalToConstant: 44.0),
			secondsView.widthAnchor.constraint(equalToConstant: 44.0),
			secondsView.heightAnchor.constraint(equalToConstant: 44.0)
		])
		secondsView.set(title: "секунд")
		minuteView.set(title: "минут")
		minuteView.gradientColors = [UIColor.Button.yellowTwo, UIColor.Button.yellowOne, UIColor.Button.yellowTwo]
		secondsView.gradientColors = [UIColor.Button.yellowTwo, UIColor.Button.yellowOne, UIColor.Button.yellowTwo]
		setupTimer()
	}

	@IBAction private func purchaseTap(_ sender: Any) {
		output.purchaseAction()
	}
	@IBAction private func restoreTap(_ sender: Any) {
		output.restoreAction()
	}

	var output: Output!
	var input: Input!
	private var timer: Timer? = Timer()

	struct Input {
		var updatePrice: (_ sub: RegisteredPurchase, _ completion: @escaping (String) -> Void) -> Void
	}

	struct Output {
		let restoreAction: () -> Void
		let purchaseAction: () -> Void
	}

	private func setTimer(_ time: Int) {
		secondsView.set(time: timeCount(time % 60))
		minuteView.set(time: timeCount((time / 60) % 60))
	}

	private func setupTimer() {
		let interval = LocalStore.promo6MonthTimer - Int(Date().timeIntervalSince1970)
		var count: Int = interval
		timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
			count -= 1
			self?.setTimer(count)
		}
	}

	func timeCount(_ time: Int) -> String {
		if time < 10 {
			return "0" + time.stringValue
		} else {
			return time.stringValue
		}
	}

	func configurate(sub: RegisteredPurchase, have: Bool = false) {
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
		input.updatePrice(sub) { [weak self] price in
			self?.priceLabel.text = "\(price) / 3 мес"
		}
	}

	deinit {
		timer?.invalidate()
		timer = nil
		print("deinit SubscriptionPromoCollectionViewCell")
	}
}
