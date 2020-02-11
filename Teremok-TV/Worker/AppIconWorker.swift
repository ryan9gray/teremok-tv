//
//  AppIconWorker.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 11.02.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

struct AppIconWorker {

	static func checkShedule() {
		var icon: Icons?
		switch Date() {
			case ...Date(year: 2020, month: 2, day: 16):
				icon = .color
			case ...Date(year: 2020, month: 2, day: 19):
				icon = .green
			default:
				break
		}
		guard UIApplication.shared.alternateIconName != icon?.rawValue else { return }
		UIApplication.shared.setAlternateIconName(icon?.rawValue)
	}

	enum Icons: String {
		case color = "AppIconAltColor"
		case green = "AppIconAltGreen"
	}
}
