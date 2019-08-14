//
//  KeyboardShowable.swift
//  gu
//
//  Created by Maxim Shelepyuk on 10/11/2017.
//  Copyright © 2017 tt. All rights reserved.
//

import UIKit

@objc protocol KeyboardShowable: class {
    func keyboardDidShow(_ notification: Notification)
    func keyboardDidHide(_ notification: Notification)
}

extension KeyboardShowable {
    
    func subscribeForKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow),
            name: UIResponder.keyboardDidShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide),
            name: UIResponder.keyboardDidHideNotification,
            object: nil
        )
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
}

protocol ScrollViewKeyboardShowable: KeyboardShowable {
    var scrollView: UIScrollView! { get }
}
protocol TextFieldKeyboardShowable: KeyboardShowable {
    var textField: UIScrollView! { get }
}


extension ScrollViewKeyboardShowable where Self: UIViewController {
    
    func keyboardDidShow(with notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
        }
    }
    
    func keyboardDidHide(with notification: Notification) {
        scrollView.contentInset.bottom = 0
    }
}
