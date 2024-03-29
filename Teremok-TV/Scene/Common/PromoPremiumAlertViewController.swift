//
//  FreePremiumAlertViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25.12.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring

class PromoPremiumAlertViewController: UIViewController {
	@IBOutlet private var descriptionLabel: UILabel!
	@IBOutlet private var alertView: DesignableView!
	@IBOutlet private var choseButton: UIRoundedButtonWithGradientAndShadow!
	@IBOutlet private var daysCountLabel: UILabel!
	@IBOutlet private var daysLabel: UILabel!

	@IBOutlet private var labels: [UILabel]!
	var action: (() -> Void)?

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
		choseButton.gradientColors = Style.Gradients.yellow.value
		daysCountLabel.textColor = UIColor.Label.redPromo
		daysLabel.textColor = UIColor.Label.redPromo
		setText()
	}
	
	func setText() {
		descriptionLabel.attributedText = DescriptionText.all.attributedText
		let days = (Profile.current?.untilPremiumTimeInterval ?? 0) / 86400
		daysCountLabel.text = days.stringValue
	}

	override
	func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		alertView.layer.cornerRadius = 15
	}

	enum DescriptionText: String {
		case notAuth = "Для безопасности детей у нас отсутствует реклама, но мы ежемесячно обновляем игры, пополняем каталог новыми мультфильмами, улучшаем сервисы. К сожалению, для пользователей без тарифа мы вынуждены ограничить использование приложения до 30 просмотров в месяц. Если вы постоянный зритель и довольны нашим сервисом, то вам необходимо пройти регистрацию и оформить тариф подходящий для вашего малыша. Надеемся на понимание с вашей стороны!"

		case auth = "Для безопасности детей у нас отсутствует реклама, но мы ежемесячно обновляем игры, пополняем каталог новыми мультфильмами, улучшаем сервисы. К сожалению, для пользователей без тарифа мы вынуждены ограничить использование приложения до 30 просмотров в месяц. Если вы постоянный зритель и довольны нашим сервисом, то вам необходимо оформить тариф подходящий для вашего малыша. Надеемся на понимание с вашей стороны!"

		case all = "У нас отсутствует реклама в приложении, но мы обновляем игры, пополняем каталог мультфильмов, улучшаем сервисы. Для развития «Теремок-ТВ» мы вынуждены ввести лимит в 30 просмотров/месяц для зрителей без тарифа. Если вы довольны сервисом, то вы можете оформить подходящий вашему малышу тариф. В течение 1 часа для вас — скидка в 20%."

		var attributedText: NSAttributedString {
			let attributedString = NSMutableAttributedString(string: rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0)])
			let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)]
			let boldPartOfString = "В течение 1 часа для вас — скидка в 20%."
			attributedString.addAttributes(boldFontAttribute, range: NSRange(rawValue.range(of: boldPartOfString) ?? rawValue.startIndex..<rawValue.endIndex, in: rawValue))
			return attributedString
		}
	}
}
