//
//  PromoWorker.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25.12.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Foundation

struct PromoWorker {

	func setData() {
		LocalStore.promo6MonthTimer = CLong(Date().addingTimeInterval(360).timeIntervalSince1970)
	}

	func getCurrentTime() -> Date {
		return Date(timeIntervalSince1970: TimeInterval(LocalStore.promo6MonthTimer))
	}
}
