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
    private let gameHelper = AlphabetGameHelper()
    private var audioPlayer: AVAudioPlayer?

    var input: Input!
    var output: Output!

    struct Input {
        var colors: [ColorsMaster.Colors]
        var isHard: Bool
    }

    struct Output {
        var result: (AlphaviteMaster.Statistic) -> Void
        var nextChoice: () -> Void
    }

    var currentColor: ColorsMaster.Colors = .white

    private var timer = Timer()
    private let limit: CGFloat = 10.0
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
    var points: Int = 0 {
        didSet {
            pointsLabel.text = points.stringValue
        }
    }

    private var right: GameModel.Option = .left

    @IBAction private func rightTap(_ sender: Any) {
        result(view: rightView, answer: .right)
    }

    @IBAction private func leftTap(_ sender: Any) {
        result(view: leftView, answer: .left)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        progressBar.isHidden = !input.isHard
        pointsView.isHidden = !input.isHard
        if input.isHard {
            pointsView.gradientColors = Style.Gradients.orange.value
        }

        nextColor()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer.invalidate()
        audioPlayer?.stop()
    }

    private func setupUI() {
        pointsLabel.textColor = UIColor.ColorsGame.purp
        pointTitleLabel.textColor = UIColor.ColorsGame.purp
    }

    func nextColor() {
        guard let color = input.colors.randomElement() else {
            output.nextChoice()
            return
        }

        displayChoice(color: color, wrong: gameHelper.randomColor(from: color), image: UIImage(named: ColorsMaster.Pack[color]!))
        playSounds(gameHelper.getSounds(name: color.sound))
    }

    private func displayChoice(color: ColorsMaster.Colors, wrong: ColorsMaster.Colors, image: UIImage?) {
        reset()
        right = GameModel.Option(rawValue: Int.random(in: 0...1))!
        currentColor = color

        switch right {
            case .left:
                leftView.setGradient(color)
                rightView.setGradient(wrong)
            case .right:
                leftView.setGradient(wrong)
                rightView.setGradient(color)
        }
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.leftView.alpha = 1.0
                self.rightView.alpha = 1.0
                self.leftView.isHidden = false
                self.rightView.isHidden = false
                self.stackView.layoutIfNeeded()
        })
        imageContainer.borderColor = UIColor.Alphavite.blueTwo
        imageView.image = image
    }

    private func result(view: ColorGameContainer, answer: GameModel.Option) {
        guard !isDone else { return }

        isDone = true
        isRight = cheack(answer: answer)
        print(isRight)
        timer.invalidate()
        if isRight {
            view.setState(.access)
            points += 1
            playSounds(AlphaviteMaster.Sound.rightAnswer.url)
        } else {
            view.setState(.fail)
            playSounds(AlphaviteMaster.Sound.wrongAnswer.url)
        }
        imageContainer.borderColor = isRight ? UIColor.Alphavite.greenTwo : UIColor.Alphavite.redTwo
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                guard self.isRight else { return }
                switch answer {
                    case .left:
                        self.rightView.alpha = 0.0
                        self.rightView.isHidden = true
                    case .right:
                        self.leftView.alpha = 0.0
                        self.leftView.isHidden = true
                }
                self.stackView.layoutIfNeeded()
        }) { _ in

        }

        //output.result(AlphaviteMaster.Statistic(char: currentChar, seconds: Int(seconds), isRight: isRight))
    }

    private func reset() {
        leftView.setState(.brash)
        rightView.setState(.brash)
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
    private func playSounds(_ url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("no file)")
        }
        audioPlayer?.play()
    }
}
