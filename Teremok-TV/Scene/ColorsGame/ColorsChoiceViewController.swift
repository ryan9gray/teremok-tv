//
//  ColorsChoiceViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring
import AVKit
import Lottie

class ColorsChoiceViewController: GameViewController {
    @IBOutlet private var rightView: ColorGameContainer!
    @IBOutlet private var leftView: ColorGameContainer!
    @IBOutlet private var pointsLabel: UILabel!
    @IBOutlet private var progressBar: AMProgressBar!
    @IBOutlet private var pointsView: GradientView!
    @IBOutlet private var pointTitleLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var imageContainer: DesignableView!
    @IBOutlet private var stackView: UIStackView!

    var input: Input!
    var output: Output!

    struct Input {
        var words: [String: String]
        var isHard: Bool
    }

    struct Output {
        var result: (AlphaviteMaster.Statistic) -> Void
        var nextChoice: () -> Void
    }

    private var timer = Timer()
    private let limit: CGFloat = 30.0
    private var progress: CGFloat {
        return seconds / limit
    }
    private var isDone = false
    private var isRight = false
    private var seconds: CGFloat = 0.0 {
        didSet {
            guard input.isHard else { return }
            progressBar.setProgress(progress: progress, animated: true)
            if seconds == limit {
                timer.invalidate()
                nextColor()
            }
        }
    }

    private var right: GameModel.Option = .left

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func nextColor() {

    }

    private func reset() {
          isDone = false
          seconds = 0
          fireTimer()
    }

    private func cheack(answer: GameModel.Option) -> Bool {
        return right == answer
    }

    private func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.seconds += 1
        }
    }
}
