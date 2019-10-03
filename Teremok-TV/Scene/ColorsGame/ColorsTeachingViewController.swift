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
    @IBOutlet private var imageContainer: ColorGameContainer!

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

        titleLabel.textColor = UIColor.Alphavite.blueTwo
        titleLabel.strokeSize = 12.0
        titleLabel.strokePosition = .center
        titleLabel.gradientColors = [ UIColor.white ]

        start()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        audioPlayer?.stop()
    }

    func start() {

    }
    private func nextChar() {
        guard let color = input.colors.popLast() else {
            finish()
            return
        }
        //guard let name = AlphaviteMaster.Char[color] else { return }

        //charLabel.text = color

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

//        playSounds(gameHelper.getSounds(name: name)) { [weak self] in
//            self?.nextImage(color)
//        }
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
        audioPlayer?.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            completion()
        }
    }
}
