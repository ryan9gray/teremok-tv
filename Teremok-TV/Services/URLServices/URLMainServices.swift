//
//  URLMainServices.swift
//  gu
//
//  Created by NRokudaime on 03.08.17.
//  Copyright © 2017 tt. All rights reserved.
//

import UIKit

class URLMainServices: URLServices {
    func open(link: AppURL) -> Bool {
        if let url = URL(string: link.rawValue), UIApplication.shared.canOpenURL(url) {
            return open(url: url)
        } else {
            return false
        }
    }
    
    func open(link: String) -> Bool {
        let cleanString = link.removingWhitespaces()
        if let url = URL(string: cleanString), UIApplication.shared.canOpenURL(url) {
            return open(url: url)
        } else {
            return false
        }
    }
    
    func open(url: URL) -> Bool {
        if UIApplication.shared.canOpenURL(url) {
            let stringURL = url.absoluteString
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
				let urlCopy = URL(string: stringURL)!
				UIApplication.shared.open(urlCopy, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: { (finish) in
					let a = finish
					if a {
						print("yeeee")
					} else {
						print("niiiie")
					}
				})
//                  UIApplication.shared.open(urlCopy)
            }
            return true
        } else {
            return false
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
