//
//  KeychainService.swift
//  gu
//
//  Created by tikhonov on 02/06/2017.
//  Copyright © 2017 tt. All rights reserved.
//

import Foundation

protocol KeychainService {
    var authSession: String? { get }
    var lastRequestToken: String? { get }
    func saveAuthSession(session: String)
    func savePhoneSession(phone: String)
    func resetPhoneSession()
    func resetAuthSession()
    func resetAuthentication()
    func saveLastRequestToken(token: String)
}
