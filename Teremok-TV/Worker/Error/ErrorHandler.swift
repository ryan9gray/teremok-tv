//
//  ErrorHandler.swift
//  gu
//
//  Created by Антонов Владислав Андреевич on 06.07.17.
//  Copyright © 2017 altarix. All rights reserved.
//

import UIKit

class ErrorHandler {
    static func handleApiError(_ apiResponse: ApiResponse) {
        if apiResponse.hasAuthenticationError {
            let keychain: KeychainService = MainKeychainService()
            keychain.resetAuthentication()
            ViewHierarchyWorker.resetAppForAuthentication(showExpirationAlert: true)
        }
    }
}
