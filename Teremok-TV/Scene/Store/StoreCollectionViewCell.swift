//
//  StoreCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 19/04/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class StoreCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    @IBOutlet private var mainLabel: UILabel!
    @IBOutlet private var linksTxtView: UITextView!
    @IBOutlet private var titleLabel: UILabel!

    private var action: (() -> Void)?

    @IBAction private func arrowTap(_ sender: Any) {
        action?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setLinks()
        titleLabel.textColor = UIColor.View.Label.titleText
    }

    func configure(action: @escaping () -> Void) {
        self.action = action
    }

    func setLinks() {
        linksTxtView.delegate = self

        let str = "Используя это приложение, я соглашаюсь с Политикой конфиденциальности и Пользовательским соглашением"
        let attributedString = NSMutableAttributedString(string: str)
        var foundRange = attributedString.mutableString.range(of: "Пользовательским соглашением")

        attributedString.addAttribute(.link, value: URL(string: "http://api.teremok.tv/static/agreement.html")!, range: foundRange)
        foundRange = attributedString.mutableString.range(of: "Политикой конфиденциальности")
        attributedString.addAttribute(.link, value: URL(string: "http://xmediadigital.ru/privacy")!, range: foundRange)
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 14)!, NSAttributedString.Key.foregroundColor : UIColor.View.Label.titleText]
        attributedString.addAttributes(attributes, range: NSRange(location: 0, length: str.length))
        linksTxtView.attributedText = attributedString
        linksTxtView.linkTextAttributes = [.foregroundColor : UIColor.View.yellow]
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
}