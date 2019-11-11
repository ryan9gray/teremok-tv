//
//  ColorsTeachingViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 08/09/2019.
//  Copyright © 2019 xmedia. All rights reserved.
//

import UIKit
import Spring
import AVKit

class ColorsTeachingViewController: GameViewController {
    @IBOutlet private var titleLabel: StrokeLabel!
    private var audioPlayer: AVAudioPlayer?
    @IBOutlet private var stackView: UIStackView!
    private let gameHelper = AlphabetGameHelper()
    @IBOutlet private var colorContainer: ColorGameContainer!
    @IBOutlet var objectContainer: DesignableView!
    @IBOutlet private var imageContainer: UIImageView!
    private var needPlay = true

    @IBAction private func startTap(_ sender: Any) {
        output.startChoice()
    }

    var input: Input!
    var output: Output!

    struct Output {
        let startChoice: () -> Void
    }

    struct Input {
        var colors: [ColorsMaster.Colors]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.textColor = UIColor.white
        titleLabel.strokeSize = 12.0
        titleLabel.strokePosition = .center
        titleLabel.gradientColors = ColorsMaster.Colors.violet.value

        start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        needPlay = false
        audioPlayer?.stop()
    }

    func start() {
        nextChar()
    }
    
    private func nextChar() {
        guard let color = input.colors.popLast() else {
            finish()
            return
        }

        colorContainer.setGradient(color)
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            usingSpringWithDamping: 0.9,
            initialSpringVelocity: 1,
            options: [],
            animations: {
                self.objectContainer.alpha = 0.0
                self.objectContainer.isHidden = true
                self.stackView.layoutIfNeeded()
        }, completion: {_ in
            self.playSounds(color.soundUrl) { [weak self] in
                  self?.nextImage(color)
            }
        })
    }

    private func nextImage(_ color: ColorsMaster.Colors) {
        var words = ColorsMaster.Pack[color] ?? []

        UIView.animate(withDuration: 0.5) {
            self.objectContainer.alpha = 1.0
            self.objectContainer.isHidden = false
        }

        func getWord() {
            guard let word = words.popLast() else {
                nextChar()
                return
            }
            
            imageContainer.image = UIImage(named: word)
            animateImage()
            if let path = Bundle.main.path(forResource: word, ofType: "wav") {
                playSounds(URL(fileURLWithPath: path)) {
                    getWord()
                }
            } else {
                getWord()
            }
        }
        getWord()
    }

    func finish() {
        output.startChoice()
    }

    func playSounds(_ url: URL, completion: @escaping () -> Void) {
        guard needPlay else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("no file)")
        }
        audioPlayer?.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion()
        }
    }

    private func animateImage() {
        objectContainer.animation = "shake"
        objectContainer.curve = "linear"
        objectContainer.duration =  1.0
        objectContainer.scaleX =  1.6
        objectContainer.scaleY =  1.6
        objectContainer.rotate =  3.3
        objectContainer.damping =  0.5
        objectContainer.velocity =  0.6
        objectContainer.animate()
    }
}
