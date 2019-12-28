//
//  PromoWorker.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25.12.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Foundation

struct PromoWorker {
	static func setData() {
		LocalStore.promo6MonthTimer = CLong(Date().addingTimeInterval(360).timeIntervalSince1970)
	}

	static var getCurrentDate: Date {
		Date(timeIntervalSince1970: TimeInterval(LocalStore.promo6MonthTimer))
	}

	static var getCurrentTime: TimeInterval {
		getCurrentDate.timeIntervalSince1970 - Date().timeIntervalSince1970
	}

	static var havePromo: Bool {
		getCurrentDate.dateByAddingHours(1) < Date()
	}

	static func checkPremiumChange() {
		guard !Profile.havePremium, LocalStore.lastPremiumState != Profile.havePremium else { return }

		LocalStore.needShowPromo = true
		LocalStore.lastPremiumState = false
	}
}
