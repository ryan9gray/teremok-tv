//
//  AlphaviteChoiceViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring
import AVKit
import Lottie

class AlphaviteChoiceViewController: GameViewController {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var leftChar: StrokeLabel!
    @IBOutlet private var rightChar: StrokeLabel!
    @IBOutlet private var pointsLabel: UILabel!
    @IBOutlet private var progressBar: AMProgressBar!
    @IBOutlet private var pointsView: GradientView!
    @IBOutlet private var firstItem: DesignableButton!
    @IBOutlet private var secondItem: DesignableButton!
    @IBOutlet private var pointTitleLabel: UILabel!
    @IBOutlet private var stackView: UIStackView!
    @IBOutlet private var pickView: UIView!
    @IBOutlet private var pickPlace: NSLayoutConstraint!
    @IBOutlet private var wordLabel: UILabel!
    @IBOutlet private var imageContainer: DesignableView!
    @IBOutlet private var cloudView: UIView!
    @IBOutlet private var avatar: AvatarButton!

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

    private let gameHelper = AlphabetGameHelper()
    private var audioPlayer: AVAudioPlayer?
    private var pickPlayer: AVAudioPlayer?

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
                output.result(AlphaviteMaster.Statistic(char: currentChar, seconds: Int(seconds), isRight: false))
                timer.invalidate()
                nextChar()
            }
        }
    }

    private var right: GameModel.Option = .left

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        nextChar()
        setAnimation()
    }

    private func setupUI() {

        func setupChar(_ label: StrokeLabel) {
            label.textColor = UIColor.Alphavite.blueOne
            label.strokeSize = 26.0
            label.strokeColor = .white
            label.strokePosition = .center
            label.gradientColors = [ UIColor.white ]
            label.textAlignment = .center
            label.contentMode = .center
        }

        setupChar(leftChar)
        setupChar(rightChar)

        wordLabel.textColor = .white
        pointsLabel.textColor = .white
        pointTitleLabel.textColor = .white

        avatar.isHidden = !input.isHard
           progressBar.isHidden = !input.isHard
           pointsView.isHidden = !input.isHard
           if input.isHard {
                pointsView.gradientColors = Style.Gradients.orange.value
                avatar.setupCurrent()
           }
    }

    private func setWord(_ text: String) {
        wordLabel.text = text
        let attributedWord = NSMutableAttributedString(string: text, attributes: Style.TextAttributes.alphabetWord)
        attributedWord.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0,length: 1))
        wordLabel.attributedText = attributedWord
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        timer.invalidate()
        audioPlayer?.stop()
    }

    @IBAction private func rightTap(_ sender: Any) {
        result(view: rightChar, answer: .right)
    }

    @IBAction private func leftTap(_ sender: Any) {
        result(view: leftChar, answer: .left)
    }

    var currentChar: String = ""
    var points: Int = 0 {
        didSet {
            pointsLabel.text = points.stringValue
        }
    }

    private func nextChar() {
        guard let word = input.words.keys.randomElement(), let char = input.words[word] else {
            output.nextChoice()
            return
        }
        input.words.removeValue(forKey: word)
        if let wordName = AlphaviteMaster.Names[word] {
            setWord(wordName)
        }
        displayChoice(char: char, wrong: gameHelper.randomChar(from: char), image: UIImage(named: word))
        playSounds(gameHelper.getSounds(name: word))
    }

    private func displayChoice(char: String, wrong: String, image: UIImage?) {
        reset()
        right = GameModel.Option(rawValue: Int.random(in: 0...1))!
        currentChar = char
        switch right {
        case .left:
            leftChar.text = char
            rightChar.text = wrong
        case .right:
            leftChar.text = wrong
            rightChar.text = char
        }
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.firstItem.alpha = 1.0
                self.secondItem.alpha = 1.0
                self.firstItem.isHidden = false
                self.secondItem.isHidden = false
                self.wordLabel.isHidden = true
                self.stackView.layoutIfNeeded()
        })
        imageContainer.borderColor = UIColor.Alphavite.blueTwo
        imageView.image = image
    }

    private func result(view: UIView, answer: GameModel.Option) {
        guard !isDone else { return }

        isDone = true
        isRight = cheack(answer: answer)
        print(isRight)
        timer.invalidate()
        let cross = gameHelper.drawCross(view)
        if isRight {
            points += 1
            playSounds(AlphaviteMaster.Sound.rightAnswer.url)
        } else {
            playSounds(AlphaviteMaster.Sound.wrongAnswer.url)
            view.layer.addSublayer(cross)
        }
        imageContainer.borderColor = isRight ? UIColor.Alphavite.greenTwo : UIColor.Alphavite.redTwo
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.wordLabel.isHidden = false
                guard self.isRight else { return }
                switch answer {
                    case .left:
                        self.secondItem.alpha = 0.0
                        self.secondItem.isHidden = true
                    case .right:
                        self.firstItem.alpha = 0.0
                        self.firstItem.isHidden = true
                }
                self.stackView.layoutIfNeeded()
        }) { _ in
            self.movePick(side: answer) { _ in
                self.nextChar()
                cross.removeFromSuperlayer()
            }
        }

        output.result(AlphaviteMaster.Statistic(char: currentChar, seconds: Int(seconds), isRight: isRight))
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

    private func playSounds(_ url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("no file)")
        }
        audioPlayer?.play()
    }

    // MARK: Pick Animation

    private func movePick(side: GameModel.Option, completion: @escaping (Bool) -> Void) {
        do {
            pickPlayer = try AVAudioPlayer(contentsOf: AlphaviteMaster.Sound.pickDriveTo.url)
        } catch {
            print("no file)")
        }
        pickPlayer?.play()
        let name = AlphaviteMaster.PickAnimations.end.rawValue
        pickAnimationView.animation = Animation.named(name)
        pickAnimationView.loopMode = .loop
        pickAnimationView.animationSpeed = 1.0
        pickAnimationView.play()
        let point = stackView.convert(imageContainer.frame.origin, to: view)
        var position = point.x
        pickAnimationView.transform = .identity
        switch side {
        case .left:
            let startPoint = pickView.bounds.width + view.bounds.width
            pickPlace.constant = startPoint
            position += imageContainer.bounds.width + pickView.bounds.width
            pickAnimationView.transform = CGAffineTransform(scaleX: -1, y: 1)
        case .right:
            pickPlace.constant = 0.0
        }
        view.layoutIfNeeded()
        UIView.animate(withDuration: 1.0, animations: {
                self.pickPlace.constant = position
                self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            guard let self = self else { return }

            self.pickPlayer?.stop()
            self.pickReaction(isHappy: self.cheack(answer: side), completion: { _ in
                self.hidePick(side: side, completion: completion)
            })
        })
    }

    private func hidePick(side: GameModel.Option, completion: @escaping (Bool) -> Void) {
        do {
            pickPlayer = try AVAudioPlayer(contentsOf: AlphaviteMaster.Sound.pickDriveFrom.url)
        } catch {
            print("no file)")
        }
        pickPlayer?.play()
        let name = AlphaviteMaster.PickAnimations.end.rawValue
        pickAnimationView.animation = Animation.named(name)
        pickAnimationView.loopMode = .loop
        pickAnimationView.animationSpeed = 1.0
        pickAnimationView.play()
        let position: CGFloat
        switch side {
        case .left:
            position = 0.0
        case .right:
            position = imageContainer.bounds.width + view.bounds.width
        }
        UIView.animate(withDuration: 1.0, animations: {
                self.pickPlace.constant = position
                self.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            self?.pickPlayer?.stop()
            completion(true)
        })
    }

    private func pickReaction(isHappy: Bool, completion: @escaping (Bool) -> Void) {
        if isHappy {
            playSounds(AlphaviteMaster.Sound.jump.url)
        }
        let namePick: AlphaviteMaster.PickAnimations = isHappy ? .happy : .sad
        pickAnimationView.animation = Animation.named(namePick.rawValue)
        pickAnimationView.loopMode = .playOnce
        pickAnimationView.animationSpeed = 1.5
        pickAnimationView.play(completion: completion)

        let nameCloud: AlphaviteMaster.CloudAnimations = isHappy
            ? (Bool.random() ? .happyTwo : .happyOne)
            : .sad
        cloudAnimationView.animation = Animation.named(nameCloud.rawValue)
        cloudAnimationView.loopMode = .playOnce
        cloudAnimationView.animationSpeed = 1.5
        cloudAnimationView.play { _ in
            self.setCloudMain()
        }
    }

    private var pickAnimationView: AnimationView!
    private var cloudAnimationView: AnimationView!

    private func setAnimation() {
        let namePick = AlphaviteMaster.PickAnimations.start.rawValue
        pickAnimationView = AnimationView(name: namePick)
        pickAnimationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        pickAnimationView.contentMode = .scaleAspectFit
        pickAnimationView.loopMode = .loop
        pickAnimationView.animationSpeed = 1.0
        pickAnimationView.frame = pickView.bounds
        pickView.addSubview(pickAnimationView)

        let nameCloud = AlphaviteMaster.CloudAnimations.main.rawValue
        cloudAnimationView = AnimationView(name: nameCloud)
        cloudAnimationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        cloudAnimationView.contentMode = .scaleAspectFit
        cloudAnimationView.frame = cloudView.bounds
        cloudView.addSubview(cloudAnimationView)

        setCloudMain()
    }

    private func setCloudMain() {
        cloudAnimationView.animation = Animation.named(AlphaviteMaster.CloudAnimations.main.rawValue)
        cloudAnimationView.loopMode = .loop
        cloudAnimationView.animationSpeed = 1.0
        cloudAnimationView.play()
    }
}
