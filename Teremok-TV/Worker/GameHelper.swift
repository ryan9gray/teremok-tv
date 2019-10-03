//
//  GameHelper.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 10/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

struct AlphabetGameHelper {

    func getSounds(name: String) -> URL {
        let path = Bundle.main.path(forResource: name, ofType: "wav")!
        return URL(fileURLWithPath: path)
    }


    func drawCross(_ view: UIView) -> CAShapeLayer {
        let line = CAShapeLayer()
        let linePath = UIBezierPath()

        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: view.frame.size.width, y: view.frame.size.height))
        linePath.move(to: CGPoint(x: view.frame.size.width, y: 0))
        linePath.addLine(to: CGPoint(x: 0, y: view.frame.size.height))
        linePath.stroke(with: .color, alpha: 1.0)

        line.path = linePath.cgPath
        line.strokeColor = UIColor.red.cgColor
        line.lineWidth = 15
        line.lineJoin = .round
        line.cornerRadius = 12
        return line
    }

    func randomChar(from: String) -> String {
        let keys = Array(AlphaviteMaster.Char.keys)
        let index = Int.random(in: 0..<keys.count)
        if keys[index] == from {
            let newIndex = index < 32 ?  index + 1 : index - 1
            return keys[newIndex]
        } else {
            return keys[index]
        }
    }
    func randomColor(from: ColorsMaster.Colors) -> ColorsMaster.Colors {
        let all = ColorsMaster.Colors.allValues()
        let index = Int.random(in: 0..<all.count)
        if all[index] == from {
            let newIndex = index < 8 ?  index + 1 : index - 1
            return all[newIndex]
        } else {
            return all[index]
        }
    }
}
