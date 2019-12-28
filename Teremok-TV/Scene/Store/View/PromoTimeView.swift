//
//  PromoTimeView.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 28.12.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class PromoTimeView: GradientView {
	@IBOutlet private var timeLabel: UILabel!
	@IBOutlet private var titleLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()

		vector = .vertical
		timeLabel.textColor = .white
		titleLabel.textColor = .white
		cornerRadius = 2.0
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		
	}

	func set(time: String, title: String) {
		titleLabel.text = title
		timeLabel.text = time
	}
}
