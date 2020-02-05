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

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	func setup() {
		modalTransitionStyle = .crossDissolve
		modalPresentationStyle = .overCurrentContext
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		labels.forEach { $0.textColor = UIColor.Label.titleText }
	}
}

class GetPromoCodeViewController: PromoCodeViewController {
	@IBOutlet private var firstFeatureLabel: UILabel!
	@IBOutlet private var thirdFeatureLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		firstFeatureLabel.attributedText = DescriptionText.first.attributedText
		thirdFeatureLabel.attributedText = DescriptionText.third.attributedText
    }

	enum DescriptionText: String {
		case first = "Доступ к развивающим играм: Алфавит, Цвета, Мемориз, Животные"

		case third = "Просмотр мультфильмов без интернета"

		var attributedText: NSAttributedString {
			let attributedString = NSMutableAttributedString(string: rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0)])
			let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14.0)]
			let boldPartOfString: String
			switch self {
				case .first:
					boldPartOfString = "Алфавит, Цвета, Мемориз, Животные"
				case .third:
					boldPartOfString = "без интернета"
			}
			attributedString.addAttributes(boldFontAttribute, range: NSRange(rawValue.range(of: boldPartOfString) ?? rawValue.startIndex..<rawValue.endIndex, in: rawValue))
			return attributedString
		}
	}
}
class SendPromoCodeViewController: PromoCodeViewController {
	@IBOutlet private var firstStepLabel: UILabel!
	@IBOutlet private var secondStepLabel: UILabel!
	@IBOutlet private var disclaimerLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		firstStepLabel.attributedText = DescriptionText.first.attributedText
		secondStepLabel.attributedText = DescriptionText.second.attributedText
		disclaimerLabel.attributedText = "*Важно! " <~ Style.TextAttributes.smallBoldRed + "Ссылка и промо-код  действительна только для iPhone и iPad" <~ Style.TextAttributes.small
	}

	enum DescriptionText: String {
		case first = "Отправьте ссылку на наше приложение и  подарочный промо-код подругам с маленькими детьми в общий чат или по отдельности каждой подруге."

		case second = "Как только подарочный промо-код на 30 бесплатных дней активирует 2 ваших подруги, вы автоматически получите бесплатный доступ!"

		var attributedText: NSAttributedString {
			let attributedString = NSMutableAttributedString(string: rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
			let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]
			let boldPartOfString: String
			switch self {
				case .first:
				boldPartOfString = "Отправьте ссылку"
				case .second:
				boldPartOfString = "вы автоматически получите бесплатный доступ!"
			}
			attributedString.addAttributes(boldFontAttribute, range: NSRange(rawValue.range(of: boldPartOfString) ?? rawValue.startIndex..<rawValue.endIndex, in: rawValue))
			return attributedString
		}
	}
}

class OneMorePromoCodeViewController: PromoCodeViewController {
	@IBOutlet private var disclaimerLabel: UILabel!
	@IBOutlet private var firstStepLabel: UILabel!
	@IBOutlet private var secondStepLabel: UILabel!
	@IBOutlet private var titleLabelLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()
		if Profile.current?.promo?.needActivate == 0 {
			titleLabelLabel.text = "Ура! 2 кода активировали ваши подруги с малышами. У вас премиум доступ. Но вы можете еще порадовать подруг с детьми и отправить им ссылку с промо-кодом."
		} else {
			titleLabelLabel.text = "Необходимо активировать ещё \(Profile.current?.promo?.needActivate ?? 0) промо-код и вы получите бесплатно доступ к премиум аккаунту"
		}

		firstStepLabel.attributedText = DescriptionText.first.attributedText
		secondStepLabel.attributedText = DescriptionText.second.attributedText
		disclaimerLabel.attributedText = "*Важно! " <~ Style.TextAttributes.smallBoldRed
			+ "Ссылка и промо-код  действительна только для iPhone и iPad" <~ Style.TextAttributes.small
	}

	enum DescriptionText: String {
		case first = "Ссылку на наше приложение и подарочный промо-код отправьте подругам с маленькими детьми."

		case second = "Как только подарочный промо-код на 30 бесплатных дней активирует 2 ваших подруги, вы автоматически получите бесплатный доступ ко всем функциям!"


		var attributedText: NSAttributedString {
			let attributedString = NSMutableAttributedString(string: rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
			let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 13.0)]
			let boldPartOfString: String
			switch self {
				case .first:
					boldPartOfString = "Нажмите кнопку «Отправить подарок»"
				case .second:
					boldPartOfString = "вы автоматически получите бесплатный доступ"
			}
			attributedString.addAttributes(boldFontAttribute, range: NSRange(rawValue.range(of: boldPartOfString) ?? rawValue.startIndex..<rawValue.endIndex, in: rawValue))
			return attributedString
		}
	}
}

class ActivatedPromoCodeViewController: UIViewController {
	@IBOutlet private var labels: [UILabel]!

	@IBAction func fonClick(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	func setup() {
		modalTransitionStyle = .crossDissolve
		modalPresentationStyle = .overCurrentContext
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		labels.forEach { $0.textColor = UIColor.Label.titleText }
	}

}
