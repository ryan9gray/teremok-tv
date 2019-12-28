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
		setText()
	}
	
	func setText() {
		if Profile.isAuthorized {
			descriptionLabel.attributedText = DescriptionText.auth.attributedText
		} else{
			descriptionLabel.attributedText = DescriptionText.notAuth.attributedText
		}
	}

	override
	func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()

		alertView.layer.cornerRadius = 15
	}

	enum DescriptionText: String {
		case notAuth = "Уважаемый пользователь, приветствуем! Для безопасности детей у нас отсутствует реклама, но мы ежемесячно обновляем игры, пополняем каталог новыми мультфильмами, улучшаем сервисы. К сожалению, для пользователей без тарифа мы вынуждены ограничить использование приложения до 30 просмотров в месяц. Если вы постоянный зритель и довольны нашим сервисом, то вам необходимо пройти регистрацию и оформить тариф подходящий для вашего малыша. Надеемся на понимание с вашей стороны! /nРедакция «Теремок-ТВ».»"

		case  auth = "Уважаемый пользователь, приветствуем! Для безопасности детей у нас отсутствует реклама, но мы ежемесячно обновляем игры, пополняем каталог новыми мультфильмами, улучшаем сервисы. К сожалению, для пользователей без тарифа мы вынуждены ограничить использование приложения до 30 просмотров в месяц. Если вы постоянный зритель и довольны нашим сервисом, то вам необходимо оформить тариф подходящий для вашего малыша. Надеемся на понимание с вашей стороны! /nРедакция «Теремок-ТВ».»"

		var attributedText: NSAttributedString {
			let attributedString = NSMutableAttributedString(string: self.rawValue, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 15.0)])
			let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15.0)]

			let boldPartOfString = "мы вынуждены ограничить использование приложения до 30 просмотров в месяц"
			let secondBoldPartOfString: String
			switch self {
				case .auth:
					secondBoldPartOfString = "вам необходимо оформить тариф"
				case .notAuth:
					secondBoldPartOfString = "вам необходимо пройти регистрацию и оформить тариф"
			}

			attributedString.addAttributes(boldFontAttribute, range: NSRange(self.rawValue.range(of: boldPartOfString) ?? self.rawValue.startIndex..<self.rawValue.endIndex, in: self.rawValue))
			attributedString.addAttributes(boldFontAttribute, range: NSRange(self.rawValue.range(of: secondBoldPartOfString) ?? self.rawValue.startIndex..<self.rawValue.endIndex, in: self.rawValue))
			return attributedString
		}
	}
}
