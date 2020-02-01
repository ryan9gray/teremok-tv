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
		disclaimerLabel.attributedText = "*Важно! " <~ Style.TextAttributes.smallRed + "Ссылка и промо-код  действительна только для iPhone и iPad" <~ Style.TextAttributes.small
	}

	enum DescriptionText: String {
		case first = "Отправьте ссылку на наше приложение и  подарочный промо-код подругам с маленькими детьми в общий чат или по отдельности каждой подруге. Нажмите кнопку «Отправить подарок», выберите мессенджер и контакты/чаты."

		case second = "Как только подарочный промо-код на 30 бесплатных дней активирует 2 ваших подруги, вы автоматически получите бесплатный доступ!"


		var attributedText: NSAttributedString {
			let attributedString = NSMutableAttributedString(string: rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0)])
			let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11.0)]
			let boldPartOfString: String
			var secondBold: String?
			switch self {
				case .first:
				boldPartOfString = "Отправьте ссылку"
				secondBold = "«Отправить подарок»"
				case .second:
				boldPartOfString = "вы автоматически получите бесплатный доступ!"
			}
			attributedString.addAttributes(boldFontAttribute, range: NSRange(rawValue.range(of: boldPartOfString) ?? rawValue.startIndex..<rawValue.endIndex, in: rawValue))
			if let bold = secondBold {
				attributedString.addAttributes(boldFontAttribute, range: NSRange(rawValue.range(of: bold) ?? rawValue.startIndex..<rawValue.endIndex, in: rawValue))
			}
			return attributedString
		}
	}
}

class OneMorePromoCodeViewController: PromoCodeViewController {
	@IBOutlet private var disclaimerLabel: UILabel!
	@IBOutlet private var firstStepLabel: UILabel!
	@IBOutlet private var secondStepLabel: UILabel!

	override func viewDidLoad() {
		super.viewDidLoad()

		firstStepLabel.attributedText = DescriptionText.first.attributedText
		secondStepLabel.attributedText = DescriptionText.second.attributedText
		disclaimerLabel.attributedText = "*Важно! " <~ Style.TextAttributes.smallRed + "Ссылка и промо-код  действительна только для iPhone и iPad" <~ Style.TextAttributes.small
	}

	enum DescriptionText: String {
		case first = "Ссылку на наше приложение и подарочный промо-код отправьте подругам с маленькими детьми. Нажмите кнопку «Отправить подарок» и выберите мессенджер и контакты/чаты."

		case second = "Как только подарочный промо-код на 30 бесплатных дней активирует 2 ваших подруги, вы автоматически получите бесплатный доступ ко всем функциям!"


		var attributedText: NSAttributedString {
			let attributedString = NSMutableAttributedString(string: rawValue, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0)])
			let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 11.0)]
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
	@IBAction func fonClick(_ sender: Any) {
		dismiss(animated: true, completion: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

}
