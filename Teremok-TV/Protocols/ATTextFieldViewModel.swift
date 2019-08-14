//
//  ATTextFieldViewModel.swift
//  vapteke
//
//  Created by R9G on 23.06.2018.
//  Copyright © 2018 550550. All rights reserved.
//

import UIKit
//import ATTextField

protocol ATTextFieldViewModel {
    var font: UIFont { get }
    var headLabelFont: UIFont { get }
    var alertLabelFont: UIFont { get }
    var headColor: UIColor { get }
    var baseLineColor: UIColor { get }
    var highlightedBaseLineColor: UIColor { get }
    var textColor: UIColor { get }
    var alertColor: UIColor { get }
    var alertLabelNumberOfLines: Int { get }
    var textViewTopInset: CGFloat { get }
    var baseLineTopInset: CGFloat { get }
    var alertLabelTopInset: CGFloat { get }
    var hideHeadWhenTextIsEmpty: Bool { get }
    var highLightBaseLineWhenActive: Bool { get }
    var hideAlertWhenBecomeActive: Bool { get }
    var hasSecureButton: Bool { get }
    var placeholderAttributes: [NSAttributedString.Key: Any] { get }
    var placeholderText: String { get }
    var headText: String { get }
}

extension ATTextFieldViewModel {
    var font: UIFont {
        return .defaultFont(ofSize: 17.0, for: .regular)
    }
    
    var headLabelFont: UIFont {
        return .defaultFont(ofSize: 11.0, for: .regular)
    }
    
    var alertLabelFont: UIFont {
        return .defaultFont(ofSize: 11.0, for: .regular)
    }
    
    var headColor: UIColor {
        return UIColor.TextField.head
    }
    
    var baseLineColor: UIColor {
        return UIColor.TextField.baseline
    }
    
    var highlightedBaseLineColor: UIColor {
        return UIColor.TextField.baselineActive
    }
    
    var textColor: UIColor {
        return UIColor.TextField.text
    }
    
    var alertColor: UIColor {
        return UIColor.TextField.text
    }
    
    var alertLabelNumberOfLines: Int {
        return 0
    }
    
    var textViewTopInset: CGFloat {
        return 3.0
    }
    
    var baseLineTopInset: CGFloat {
        return 8.0
    }
    
    var alertLabelTopInset: CGFloat {
        return 3.0
    }
    
    var hideHeadWhenTextIsEmpty: Bool {
        return true
    }
    
    var highLightBaseLineWhenActive: Bool {
        return true
    }
    
    var hideAlertWhenBecomeActive: Bool {
        return true
    }
    
    var hasSecureButton: Bool {
        return false
    }
    
    var placeholderAttributes: [NSAttributedString.Key: Any] {
        return [
            NSAttributedString.Key.foregroundColor: UIColor.TextField.placeholder,
            NSAttributedString.Key.font: UIFont.defaultFont(ofSize: 17.0, for: .regular)
        ]
    }
    
    var headText: String {
        return placeholderText
    }
}

//extension ATTextField {
//    func confireWith(viewModel: ATTextFieldViewModel) {
//        headColor = viewModel.headColor
//        headLabel.font = viewModel.headLabelFont
//        headText = viewModel.headText
//        attributedPlaceholder = NSAttributedString(string: viewModel.placeholderText, attributes: viewModel.placeholderAttributes)
//        baseLineColor = viewModel.baseLineColor
//        alertColor = viewModel.alertColor
//        alertLabel.font = viewModel.alertLabelFont
//        alertLabel.numberOfLines = viewModel.alertLabelNumberOfLines
//        font = viewModel.font
//        textColor = viewModel.textColor
//        hideHeadWhenTextFieldIsEmpty = viewModel.hideHeadWhenTextIsEmpty
//        highlightBaseLineWhenActive = viewModel.highLightBaseLineWhenActive
//        highlightedBaseLineColor = viewModel.highlightedBaseLineColor
//        hideAlertWhenBecomeActive = viewModel.hideAlertWhenBecomeActive
//        textViewEdge.top = viewModel.textViewTopInset
//        baseLineEdge.top = viewModel.baseLineTopInset
//        alertLabelEdge.top = viewModel.alertLabelTopInset
//
//        if viewModel.hasSecureButton {
//            addSecureInputButton()
//        }
//    }
//}
//
//struct ATDefaultTextFieldViewModel: ATTextFieldViewModel {
//    var placeholderText: String
//}
//
//struct ATPasswordTextFieldViewModel: ATTextFieldViewModel {
//    var placeholderText: String {
//        return "Пароль"
//    }
//}
//
//struct ATPasswordTextFieldWithSecureButtonViewModel: ATTextFieldViewModel {
//    var placeholderText: String
//
//    var hasSecureButton: Bool {
//        return true
//    }
//}
//
//struct ATElectricityCounterValueTextFieldViewModel: ATTextFieldViewModel {
//    var placeholderText: String {
//        return ""
//    }
//
//    var headLabelFont: UIFont {
//        return .defaultFont(ofSize: 16.0, for: .regular)
//    }
//
//    var font: UIFont {
//        return .defaultFont(ofSize: 17.0, for: .bold)
//    }
//
//    var textViewTopInset: CGFloat {
//        return 20.0
//    }
//}
//
//struct ATWaterCounterValueTextFieldViewModel: ATTextFieldViewModel {
//    var placeholderText: String {
//        return ""
//    }
//
//    var headLabelFont: UIFont {
//        return .defaultFont(ofSize: 11.0, for: .bold)
//    }
//
//    var font: UIFont {
//        return .defaultFont(ofSize: 17.0, for: .regular)
//    }
//
//    var alertColor: UIColor {
//        return UIColor.TextField.placeholder
//    }
//
//    var hideAlertWhenBecomeActive: Bool {
//        return false
//    }
//
//}
