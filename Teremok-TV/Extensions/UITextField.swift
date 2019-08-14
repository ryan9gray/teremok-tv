//
//  UITextField.swift
//  vapteke
//
//  Created by R9G on 23.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import UIKit

extension UITextField {
    func addSecureInputButton() {
        let showPasswordButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        showPasswordButton.setImage(#imageLiteral(resourceName: "icEyeOn"), for: .normal)
        showPasswordButton.setImage(#imageLiteral(resourceName: "icEye"), for: .selected)
        showPasswordButton.addTarget(self, action: #selector(clearButtonTouched), for: .touchUpInside)
        clearButtonMode = .never
        rightViewMode = .whileEditing
        if rightView == nil {
            rightView = showPasswordButton
        }
    }
    
    @objc func clearButtonTouched(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        resignFirstResponder()
        isSecureTextEntry = !sender.isSelected
        becomeFirstResponder()
    }
}

extension UITextField {
    
    @IBInspectable var defaultAccessoryView: Bool {
        get {
            return inputAccessoryView?.isKind(of: UIToolbar.self) ?? false
        }
        set {
            inputAccessoryView = newValue ? UIToolbar.inputAccessoryWith(style: .done(self)) : nil
        }
    }
}

extension UITextField {
    
    var isEmpty: Bool {
        if let text = text {
            return text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return true
    }
}
