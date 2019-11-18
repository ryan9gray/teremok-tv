//
//  DisposeBag.swift
//  Teremok-TV
//
//  Created by Eugene Ivanov on 19.11.2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

class DisposeBag {
    private var subscriptions: [Subscription] = []

    func add(_ subscription: Subscription) {
        subscriptions.append(subscription)
    }
}

extension Subscription {
    func disposed(by disposeBag: DisposeBag) {
        disposeBag.add(self)
    }
}
