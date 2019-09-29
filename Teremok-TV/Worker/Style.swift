//
//  Style.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

enum Style {
    enum Gradients {
        typealias RawValue = [UIColor]

        case beige
        case yellow
        case orange
        case brown
        case alphavitePlay
        case blue
        case red
        case green
        case lightGray
        case blueBorder
        case lightBlue
    }

    enum TextAttributes {
        static let alpavitreMain: [NSAttributedString.Key: Any] = [
            .font: Font.alphaviteMain
        ]
        static let alpavitreChar: [NSAttributedString.Key: Any] = [
            .font: Font.istokWeb
        ]
        static let gameList: [NSAttributedString.Key: Any] = [
            .font: Font.alphaviteMain(size: 32.0),
            .foregroundColor: UIColor.white
        ]
        static let alphabetWordRed: [NSAttributedString.Key: Any] = [
            .font: Font.istokWeb(size: 24.0),
            .foregroundColor: UIColor.red,
        ]
        static let alphabetWord: [NSAttributedString.Key: Any] = [
            .font: Font.istokWeb(size: 24.0),
            .foregroundColor: UIColor.Alphavite.blueTwo,
        ]
    }

    enum Font {
        static func alphaviteMain(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "Foo-Regular", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size, weight: .regular)
            }
        }
        static func helveticaBold(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "HelveticaNeue-Bold", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size, weight: .regular)
            }
        }
        static func istokWeb(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "IstokWeb-Bold", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size, weight: .regular)
            }
        }
        static func montsserat(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "Montserrat Alternates-Regular", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size, weight: .regular)
            }
        }
        static func arial(size: CGFloat) -> UIFont {
            if let font = UIFont(name: "Arial-Black", size: size) {
                return font
            } else {
                return UIFont.systemFont(ofSize: size, weight: .regular)
            }
        }
    }
}

extension Style.Gradients {
    var value: [UIColor] {
        get {
            switch self {
            case .beige:
                return [.white, UIColor.Button.beige]
            case .yellow:
                return [UIColor.Button.yellowOne, UIColor.Button.yellowTwo]
            case .orange:
                return [UIColor.Alphavite.orangeOne, UIColor.Alphavite.orangeTwo]
            case .brown:
                return [UIColor.Alphavite.brownOne, UIColor.Alphavite.brownTwo]
            case .alphavitePlay:
                return [UIColor.Alphavite.playOne, UIColor.Alphavite.playTwo]
            case .blue:
                return [UIColor.Alphavite.blueOne, UIColor.Alphavite.blueTwo]
            case .red:
                return [UIColor.Alphavite.redOne, UIColor.Alphavite.redTwo]
            case .green:
                return [UIColor.Alphavite.greenOne, UIColor.Alphavite.greenTwo]
            case .lightGray:
                return [UIColor.Button.lightGray, .white]
            case .blueBorder:
                return [UIColor.Alphavite.blueOne, .white]
                case .lightBlue:
                return []
            }

        }
    }
}

protocol Applicable {
    associatedtype Applicant

    func apply(_ object: Applicant)
}

precedencegroup StylePrecedence {
    associativity: left
    higherThan: AdditionPrecedence
}

infix operator <~: StylePrecedence

@discardableResult
func <~<T: Applicable>(object: T.Applicant, applicable: T) -> T.Applicant {
    applicable.apply(object)
    return object
}

func <~ (string: String, attributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
    return NSAttributedString(string: string, attributes: attributes)
}

@discardableResult
func <~ (string: NSMutableAttributedString, attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
    string.addAttributes(attributes, range: NSRange(location: 0, length: string.length))
    return string
}

func <~ (attributesTo: [NSAttributedString.Key: Any], attributesFrom: [NSAttributedString.Key: Any]) -> [NSAttributedString.Key: Any] {
    var resultAttributes = attributesTo
    attributesFrom.forEach { item in
        resultAttributes[item.key] = item.value
    }
    return resultAttributes
}
