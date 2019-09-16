//
//  ChoiceAnimalViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 25/05/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AVKit
import Lottie
import Spring

class ChoiceAnimalViewController: GameViewController, AVAudioPlayerDelegate {
    @IBOutlet private var characterLabel: UILabel!
    @IBOutlet private var animalLabel: UILabel!
    @IBOutlet private var firstAnimalImageView: UIImageView!
    @IBOutlet private var secondAnimalImageView: UIImageView!
    @IBOutlet private var princesImageView: UIImageView!
    @IBOutlet private var firstItem: UIView!
    @IBOutlet private var secondItem: UIView!
    @IBOutlet private var secondCloud: UIImageView!
    @IBOutlet private var firstCloud: UIImageView!
    @IBOutlet private var animationView: AnimationView!
    @IBOutlet private var progressBar: AMProgressBar!
    @IBOutlet private var pointsView: UIView!
    @IBOutlet private var pointLabel: UILabel!
    private var audioPlayer: AVAudioPlayer?

    @IBAction func firstClick(_ sender: Any) {
        result(view: secondItem, answer: .left)
    }

    @IBAction func secondClick(_ sender: Any) {
        result(view: firstItem, answer: .right)
    }

    var input: Input!
    var output: Output!

    struct Input {
        var animal: AnimalsGame.Animal
        var wrongImage: UIImage
        var isHard: Bool
        var points: Int
    }
    struct Output {
        var nextChoice: (Bool, Int) -> Void
    }

    private var timer = Timer()
    private let limit: CGFloat = 15.0
    private var progress: CGFloat {
        return seconds / limit
    }

    private var isDone = false
    private var isRight = false

    private var seconds: CGFloat = 0.0 {
        didSet {
            progressBar.setProgress(progress: progress, animated: true)
            if seconds == limit {
                timer.invalidate()
                output.nextChoice(false, Int(seconds))
            }
        }
    }
    private var right: GameModel.Option = .left
    
    override func viewDidLoad() {
        super.viewDidLoad()

        characterLabel.textColor = UIColor.View.Label.orange
        animalLabel.textColor = .white
        animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        animationView.contentMode = .scaleAspectFill
        animationView.clipsToBounds = false
        animationView.loopMode = .playOnce
        animationView.animationSpeed = 1.0
        pointLabel.textColor = UIColor.View.Label.orange
        progressBar.isHidden = !input.isHard
        pointsView.isHidden = !input.isHard
        if input.isHard {
            pointLabel.text = input.points.stringValue
            fireTimer()
        }
        displayChoice(animal: input.animal, image: input.wrongImage)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
        audioPlayer?.stop()
    }

    func result(view: UIView, answer: GameModel.Option) {
        guard !isDone else { return }
        
        isDone = true
        isRight = cheack(answer: answer)
        timer.invalidate()
        if isRight {
            princesImageView.image = ChoiceAnimal.PrincesState.happy.image
            playAnimation()
            view.isHidden = true
        } else {
            princesImageView.image = ChoiceAnimal.PrincesState.angry.image
            if answer == .left {
                firstCloud.image = UIImage(named: "icAnimalCloudRed")
            } else {
                secondCloud.image = UIImage(named: "icAnimalCloudRed")
            }
        }
        playReaction(isRight: isRight)
    }

    func playReaction(isRight: Bool) {
        let url: URL
        if isRight {
            let path = Bundle.main.path(forResource: ChoiceAnimal.funSounds.randomElement()!, ofType: "mp3")!
            url = URL(fileURLWithPath: path)
        } else {
            let path = Bundle.main.path(forResource: ChoiceAnimal.sadSounds.randomElement()!, ofType: "wav")!
            url = URL(fileURLWithPath: path)
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("no file)")
        }
        audioPlayer?.prepareToPlay()
        audioPlayer?.delegate = self
        audioPlayer?.play()
    }

    func playAnimation() {
        let name = ChoiceAnimal.fireworks.randomElement()!
        let av = Animation.named(name)
        animationView.animation = av
        animationView.play()
    }

    func cheack(answer: GameModel.Option) -> Bool {
        return right == answer
    }

    func fireTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.seconds += 1
        }
    }

    func displayChoice(animal: AnimalsGame.Animal, image: UIImage) {
        right = GameModel.Option(rawValue: Int(arc4random_uniform(2)))!
        switch right {
        case .left:
            firstAnimalImageView.image = animal.image
            secondAnimalImageView.image = image
        case .right:
            secondAnimalImageView.image = animal.image
            firstAnimalImageView.image = image
        }
        let rusName = animal.name
        characterLabel.text = String(rusName.first!)
        animalLabel.text = rusName
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: animal.sound)
        } catch {
            print("no file)")
        }
        audioPlayer?.play()
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("end playing")
        if isDone {
            output.nextChoice(isRight, Int(seconds))
        }
    }
}
