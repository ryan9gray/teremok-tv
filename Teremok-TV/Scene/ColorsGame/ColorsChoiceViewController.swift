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
    @IBOutlet private var redMonsterView: UIView!
    @IBOutlet private var greenMonsterView: UIView!

    var input: Input!
    var output: Output!

    struct Input {
        var colors: [String: ColorsMaster.Colors]
        var isHard: Bool
    }

    struct Output {
        var result: (AlphaviteMaster.Statistic) -> Void
        var nextChoice: () -> Void
    }

    var currentImage: UIImage?

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
                output.result(AlphaviteMaster.Statistic(char: currentColor.rawValue, seconds: Int(limit), isRight: false))
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

    private let imageFillter = ImageFillter()
    private var currentColor: ColorsMaster.Colors = .black

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
            pointsView.gradientColors = Style.Gradients.yellow.value
        }
        setAnimation()
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
        input.colors.removeValue(forKey: color.key)
        displayChoice(color: color, wrong: gameHelper.randomColor(from: color.value), image: UIImage(named: color.key))
    }
    
    private func displayChoice(color: (key: String, value: ColorsMaster.Colors), wrong: ColorsMaster.Colors, image: UIImage?) {
        reset()
        right = GameModel.Option(rawValue: Int.random(in: 0...1))!
        currentImage = image
        currentColor = color.value
        switch right {
            case .left:
                leftView.setGradient(color.value)
                rightView.setGradient(wrong)
            case .right:
                leftView.setGradient(wrong)
                rightView.setGradient(color.value)
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
        }, completion: { _ in
            self.playSounds(self.gameHelper.getSounds(name: color.key))
        })
        imageContainer.borderColor = UIColor.Alphavite.blueTwo
        imageView.image = imageFillter.monochrome(image)
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
            playSounds(ColorsMaster.EmotionalsHappy.allCases.randomElement()!.url)
        } else {
            view.setState(.fail)
            playSounds(ColorsMaster.EmotionalsSad.allCases.randomElement()!.url)
        }
        imageView.image = currentImage
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
            self.monstersReaction(isHappy: self.isRight) { _ in
                self.nextColor()
            }
        }
        output.result(AlphaviteMaster.Statistic(char: currentColor.rawValue, seconds: Int(seconds), isRight: isRight))
    }

    private func monstersReaction(isHappy: Bool, completion: @escaping (Bool) -> Void) {
        let namePick: ColorsMaster.GreenAnimation = isHappy
            ? (Bool.random() ? .happy : .happyTwo)
            : (Bool.random() ? .sad : .sadTwo)
        greenAnimationView.animation = Animation.named(namePick.rawValue)
        greenAnimationView.loopMode = .playOnce
        greenAnimationView.animationSpeed = 1
        greenAnimationView.play(completion: completion)

        let redAnimation: ColorsMaster.RedAnimation = isHappy
            ? (Bool.random() ? .happy : .happyTwo)
            : (Bool.random() ? .sad : .sadTwo)
        redAnimationView.animation = Animation.named(redAnimation.rawValue)
        redAnimationView.loopMode = .playOnce
        redAnimationView.animationSpeed = 1
        redAnimationView.play { _ in
            self.setMainAnimation()
        }

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

    private var greenAnimationView: AnimationView = AnimationView()
    private var redAnimationView: AnimationView = AnimationView()

    private func setAnimation() {
        let greenName = ColorsMaster.GreenAnimation.main.rawValue
        greenAnimationView = AnimationView(name: greenName)
        greenAnimationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        greenAnimationView.contentMode = .scaleAspectFit
        greenAnimationView.loopMode = .loop
        greenAnimationView.animationSpeed = 1.0
        greenAnimationView.frame = greenMonsterView.bounds
        greenMonsterView.addSubview(greenAnimationView)

        let redName = ColorsMaster.RedAnimation.main.rawValue
        redAnimationView = AnimationView(name: redName)
        redAnimationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        redAnimationView.contentMode = .scaleAspectFit
        redAnimationView.frame = redMonsterView.bounds
        redMonsterView.addSubview(redAnimationView)

        setMainAnimation()
    }

    private func setMainAnimation() {
        redAnimationView.animation = Animation.named(ColorsMaster.RedAnimation.main.rawValue)
        redAnimationView.loopMode = .loop
        redAnimationView.animationSpeed = 1.0
        redAnimationView.play()

        greenAnimationView.animation = Animation.named(ColorsMaster.GreenAnimation.main.rawValue)
        greenAnimationView.loopMode = .loop
        greenAnimationView.animationSpeed = 1.0
        greenAnimationView.play()
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
