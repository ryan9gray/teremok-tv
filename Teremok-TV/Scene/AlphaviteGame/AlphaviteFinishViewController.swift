//
//  AlphaviteFinishViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit

class AlphaviteFinishViewController: GameViewController {
    @IBOutlet private var playButton: KeyButton!
    @IBOutlet private var titleLabel: StrokeLabel!
    @IBOutlet private var buttonTitleLabel: UILabel!
    @IBOutlet private var greyLabel: UILabel!
    @IBOutlet private var pointsLabel: UILabel!

    @IBAction private func playTap(_ sender: Any) {
        if isGood {
            output.nextChoice()
        } else {
            output.resume()
        }
    }

    var input: Input!
    var output: Output!

    struct Output {
        var nextChoice: () -> Void
        var resume: () -> Void
    }
    
    struct Input {
        var answers: [Bool]
    }

    var isGood = false

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.textColor = .white
        titleLabel.strokeSize = 12.0
        titleLabel.strokePosition = .center
        titleLabel.gradientColors = Style.Gradients.green.value
        pointsLabel.textColor = UIColor.Alphavite.greenOne
        greyLabel.textColor = UIColor.Alphavite.grey
        buttonTitleLabel.textColor = .white

        let right = input.answers.filter{$0}
        pointsLabel.text = "\(right.count) из \(input.answers.count)"
        presentResult(isGood: right.count > (input.answers.count - right.count))
    }

    private func presentResult(isGood: Bool) {
        self.isGood = isGood
        playButton.gradientColors = isGood ? Style.Gradients.red.value : Style.Gradients.green.value
        buttonTitleLabel.text = isGood ? "Далее" : "Заново"
        playButton.setImage(isGood ? UIImage(named: "ic-alphavitePlay") : UIImage(named: "ic-alphaviteRepeat"), for: .normal)
    }
}

