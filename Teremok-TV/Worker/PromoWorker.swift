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
		if LocalStore.needShowPromo || !LocalStore.wasFirstOpenStore {
			setDate()
			LocalStore.needShowPromo = false
			LocalStore.wasFirstOpenStore = true
		}
		return LocalStore.promo6MonthTimer > Int(Date().timeIntervalSince1970)
	}

	static func checkPremiumChange() {
		guard !Profile.havePremium, LocalStore.lastPremiumState != Profile.havePremium else { return }

		LocalStore.needShowPromo = true
	}
}

struct PromoCodeWorker {
	static var canActivate: Bool {
		Profile.current?.promo?.canActivate ?? false
	}
	static var havePromoCode: Bool {
		Profile.current?.promo?.promoCode != nil
	}
	static var wasActivated: Bool {
		(Profile.current?.promo?.activatedPromocodes ?? 0) > 0
	}
	static var activated: Int {
		Profile.current?.promo?.activatedPromocodes ?? 0
	}
}
