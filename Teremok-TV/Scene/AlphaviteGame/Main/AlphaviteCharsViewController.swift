//
//  CharactersViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 03/08/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring
import AVKit

class AlphaviteCharsViewController: GameViewController {
    @IBOutlet private var charLabel: StrokeLabel!
    @IBOutlet private var titleLabel: StrokeLabel!
    private var audioPlayer = AVAudioPlayer()
    @IBOutlet private var stackView: UIStackView!
    private let gameHelper = AlphabetGameHelper()
    @IBOutlet private var imageContainer: DesignableView!
    @IBOutlet private var imagewView: UIImageView!
    @IBOutlet private var wordLabel: UILabel!

    @IBAction private func startTap(_ sender: Any) {
        output.startChoice()
    }

    var input: Input!
    var output: Output!

    struct Output {
        let startChoice: () -> Void
    }

    struct Input {
        var chars: [String]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        wordLabel.textColor = UIColor.Alphavite.Button.blueTwo

        titleLabel.textColor = UIColor.Alphavite.Button.blueTwo
        titleLabel.strokeSize = 12.0
        titleLabel.strokePosition = .center
        titleLabel.gradientColors = [ UIColor.white ]

        charLabel.textColor = UIColor.Alphavite.Button.blueOne
        charLabel.strokeSize = 26.0
        charLabel.strokeColor = .white
        charLabel.strokePosition = .center
        charLabel.gradientColors = [ UIColor.white ]
        charLabel.textAlignment = .center
        charLabel.contentMode = .center
        start()
    }

    func start() {
        nextChar()
    }

    private func animateImage() {
        imageContainer.animation = "shake"
        imageContainer.curve = "linear"
        imageContainer.duration =  1.0
        imageContainer.scaleX =  1.6
        imageContainer.scaleY =  1.6
        imageContainer.rotate =  3.3
        imageContainer.damping =  0.5
        imageContainer.velocity =  0.6
        imageContainer.animate()
    }

    private func setWord(_ text: String) {
        wordLabel.text = text
        let attributedWord = NSMutableAttributedString(string: text, attributes: Styles.TextAttributes.alphabetWord)
        attributedWord.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSRange(location: 0,length: 1))
        wordLabel.attributedText = attributedWord
    }

    private func nextChar() {
        guard let char = input.chars.popLast() else {
            finish()
            return
        }
        guard let name = AlphaviteMaster.Char[char] else { return }

        charLabel.text = char

        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.imageContainer.alpha = 0.0
                self.imageContainer.isHidden = true
                self.stackView.layoutIfNeeded()
            }
        )

        playSounds(gameHelper.getSounds(name: name)) { [weak self] in
            self?.nextImage(char)
        }
    }

    private func nextImage(_ char: String) {
        var words = AlphaviteMaster.Words[char] ?? []
        UIView.animate(withDuration: 0.5) {
            self.imageContainer.alpha = 1.0
            self.imageContainer.isHidden = false
        }

        func getWord() {
            guard let word = words.popLast() else {
                nextChar()
                return
            }

            imagewView.image = UIImage(named: word) ?? #imageLiteral(resourceName: "icDotes")
            animateImage()
            let wordName = AlphaviteMaster.Names[word] ?? "..."
            setWord(wordName)

            playSounds(gameHelper.getSounds(name: word)) {
                getWord()
            }
        }
        getWord()
    }

    func finish() {
        output.startChoice()
    }

    func playSounds(_ url: URL, completion: @escaping () -> Void) {
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

    enum ItemType {
        case alphavite(_ char: String)
        case color(_ char: String)
    }
}
