//
//  PromoWorker.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25.12.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import Foundation

struct PromoWorker {
	static func setDate() {
		LocalStore.promo6MonthTimer = Int(Date().addingTimeInterval(3600).timeIntervalSince1970)
	}

	static var getCurrentDate: Date {
		Date(timeIntervalSince1970: TimeInterval(LocalStore.promo6MonthTimer))
	}

	static var havePromo: Bool {
		if LocalStore.needShowPromo {
			setDate()
			LocalStore.needShowPromo = false
		}
		return LocalStore.promo6MonthTimer > Int(Date().timeIntervalSince1970)
	}

	static func checkPremiumChange() {
		guard !Profile.havePremium, LocalStore.lastPremiumState != Profile.havePremium else { return }

		LocalStore.needShowPromo = true
	}
}
