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
    private var audioPlayer = AVAudioPlayer()
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
                nextChar()
            }
        }
    }

    private var right: GameModel.Option = .left

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        progressBar.isHidden = !input.isHard
        pointsView.isHidden = !input.isHard
        if input.isHard {
            pointsView.gradientColors = Styles.Gradients.orange.value
        }

        nextChar()
        setAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setWord("Слово")
    }

    private func setupUI() {
        wordLabel.textColor = .white
        leftChar.textColor = UIColor.Alphavite.Button.blueOne
        leftChar.strokeSize = 26.0
        leftChar.strokeColor = .white
        leftChar.strokePosition = .center
        leftChar.gradientColors = [ UIColor.white ]
        leftChar.textAlignment = .center
        leftChar.contentMode = .center

        rightChar.textColor = UIColor.Alphavite.Button.blueOne
        rightChar.strokeSize = 26.0
        rightChar.strokeColor = .white
        rightChar.strokePosition = .center
        rightChar.gradientColors = [ UIColor.white ]
        rightChar.textAlignment = .center
        rightChar.contentMode = .center
        pointsLabel.textColor = .white
        pointTitleLabel.textColor = .white
    }

    private func setWord(_ text: String) {
        let attributedWord = NSMutableAttributedString(string: text, attributes: Styles.TextAttributes.alphabetWord)
        attributedWord.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location:0,length:1))
        wordLabel.attributedText = attributedWord
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        audioPlayer.stop()
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
        } else {
            setWord("Слово")
        }
        displayChoice(char: char, wrong: gameHelper.randomChar(from: char), image: UIImage(named: word))
    }

    private func displayChoice(char: String, wrong: String, image: UIImage?) {
        reset()
        right = GameModel.Option(rawValue: Int(arc4random_uniform(2)))!
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
                self.stackView.layoutIfNeeded()
                self.wordLabel.isHidden = true
                self.stackView.layoutIfNeeded()
        })

        imageView.image = image
        playSounds(gameHelper.getSounds(name: AlphaviteMaster.Char[char]!)) {}
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
        } else {
            view.layer.addSublayer(cross)
        }
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.wordLabel.isHidden = false
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
            self.movePick(side: answer)
        }

        output.result(AlphaviteMaster.Statistic(char: currentChar, seconds: Int(seconds), isRight: isRight))

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.hidePick(side: answer)
            self.nextChar()
            cross.removeFromSuperlayer()
        }
    }

    func reset() {
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

    private func playSounds(_ url: URL, completion: @escaping () -> Void) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("no file)")
        }
        audioPlayer.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion()
        }
    }

    private func movePick(side: GameModel.Option) {
        let point = stackView.convert(imageContainer.frame.origin, to: view)
        var position = point.x
        switch side {
        case .left:
            pickPlace.constant = pickView.bounds.width + view.bounds.width
            position += imageContainer.bounds.width + pickView.bounds.width
        case .right:
            pickPlace.constant = 0.0
        }
        UIView.animate(withDuration: 1.0, animations: {
                self.pickPlace.constant = position
                self.view.layoutIfNeeded()
        })
    }

    private func hidePick(side: GameModel.Option) {
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
        })
    }

    private func setAnimation() {
        let name = AlphaviteMaster.PickAnimations.main.rawValue
        let av = AnimationView(name: name)
        av.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        av.contentMode = .scaleAspectFit
        av.loopMode = .loop
        av.animationSpeed = 1.0
        av.frame = pickView.bounds
        pickView.addSubview(av)
        av.play()
    }
}
