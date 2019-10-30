//
//  ResumeRoundViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/06/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import AVKit

class ResumeRoundViewController: GameViewController {
    @IBOutlet private var pointsLabel: UILabel!
    @IBOutlet private var againButtonView: UIStackView!
    @IBOutlet private var nextButtonView: UIStackView!
    @IBOutlet private var cloudImageView: UIImageView!

    var input: Input!
    var output: Output!

    struct Input {
        var answers: [Bool]
    }

    struct Output {
        var next: () -> Void
        var resume: () -> Void
    }

    @IBAction private func againClick(_ sender: Any) {
        output.resume()
    }
    @IBAction private func nextClick(_ sender: Any) {
        output.next()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let right = input.answers.filter{$0}
        presentResult(isGood: right.count > (input.answers.count - right.count))
        pointsLabel.text = right.count.stringValue
        pointsLabel.textColor = UIColor.Label.orange
    }

    private func presentResult(isGood: Bool) {
        againButtonView.isHidden = isGood
        nextButtonView.isHidden = !isGood
        let name = isGood ? "icContinueAnimals" : "icLoseAnimals"
        cloudImageView.image = UIImage(named: name)
    }
}
