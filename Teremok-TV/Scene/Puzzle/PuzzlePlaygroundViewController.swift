//
//  PuzzlePlaygroundViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit
import Lottie
import AVKit

class PuzzlePlaygroundViewController: GameViewController {
	@IBOutlet private var previewView: UIImageView!
	@IBOutlet private var scrollView: UIScrollView!
	@IBOutlet private var pieceStackView: UIStackView!
	@IBOutlet private var pieceSecondStackView: UIStackView!
	@IBOutlet private var restartButton: KeyButton!
	@IBOutlet private var playButton: KeyButton!
	@IBOutlet private var previewBackView: UIView!
	private var animationView: AnimationView = AnimationView()
	private var audioPlayer: AVAudioPlayer?
	private var buttonPlayer: AVAudioPlayer?

	enum Sound: String {
		case firework = "puzzle_firework"
		case wrong = "puzzle_wrong"

		var url: URL {
			URL(fileURLWithPath: Bundle.main.path(forResource: rawValue, ofType: "wav")!)
		}
	}

	@IBAction func restartTap(_ sender: Any) {

	}

	@IBAction func playTap(_ sender: Any) {
		createPuzzle()
		playButton.isHidden = true
		previewView.alpha = 0.2
	}

	var input: Input!
	var output: Output!

	struct Output {
		let finish: () -> Void
	}

	struct Input {
		let image: UIImage?
		let difficulty: PuzzleGameFlow.Game.Difficulty
	}
	var tapCount: Int = 0

	var correctCount = 0
	var answerAreaAray: [UIView] = []
	let fireworks: [String] = [ "puzzle_firework_1", "puzzle_firework_2", "puzzle_firework_3" ]


    override func viewDidLoad() {
        super.viewDidLoad()

		restartButton.gradientColors = [ UIColor.PuzzleGame.orangeTwo, UIColor.PuzzleGame.orangeTwo ]
		playButton.gradientColors = [ UIColor.PuzzleGame.greenOne, UIColor.PuzzleGame.greenTwo ]

		previewBackView.layer.borderWidth = 4
		previewBackView.layer.borderColor = UIColor.PuzzleGame.blueOne.cgColor
		showPreview()
		animationView = AnimationView(name: fireworks.randomElement()!)
		view.addSubview(animationView)
		animationView.isHidden = true
		animationView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
		animationView.contentMode = .scaleAspectFill
		animationView.loopMode = .playOnce
		animationView.animationSpeed = 1.0

		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "puzzle_playground", ofType: "wav")!))
			audioPlayer?.numberOfLoops = 10
			audioPlayer?.prepareToPlay()
		} catch {
			print("no file)")
		}

		do {
			buttonPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: Bundle.main.path(forResource: "puzzle_firework", ofType: "wav")!))
			buttonPlayer?.prepareToPlay()
		} catch {
			print("no file)")
		}
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		audioPlayer?.play()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)

		audioPlayer?.stop()
	}

	func showPreview() {
		guard let image = input.image?.resizeImageUsingVImage(previewView.frame.size) else { return }
		previewView.image = image
		previewView.alpha = 1
	}

	func showFirework(puzzle: UIView) {
		animationView = AnimationView(name: fireworks.randomElement()!)
		let puzzleFrame = puzzle.frame
		animationView.frame.size = CGSize(width: puzzleFrame.width*2.5, height: puzzleFrame.height*2.5)
		animationView.center = puzzleFrame.center

		view.bringSubviewToFront(animationView)
		animationView.isHidden = false
		playSounds(Sound.firework.url)

		animationView.play { [weak animationView] finish in
			animationView?.isHidden = true
		}
	}

	func restart() {
		pieceStackView.subviews.forEach { $0.removeFromSuperview() }
		pieceSecondStackView.subviews.forEach { $0.removeFromSuperview() }
	}

	private func createPuzzle() {
		guard let image = input.image?.resizeImageUsingVImage(previewView.frame.size) else { return }

		let numRows = input.difficulty.fieldSize
		let numColumns = input.difficulty.fieldSize

		var pieceAray: [Int] = []

		for i in 0...numColumns*numRows {
			pieceAray.append(i+1)
		}
		pieceStackView.subviews.forEach { $0.removeFromSuperview() }
		pieceSecondStackView.subviews.forEach { $0.removeFromSuperview() }

		let bound = previewView.bounds.size
		let movePointx: CGFloat = previewView.frame.origin.x
		let movePointy: CGFloat = previewView.frame.origin.y

		let puzzleMaker = PuzzleMaker(image: image, numRows: numRows, numColumns: numColumns)
		puzzleMaker.generatePuzzles { throwableClosure in
			do {
				let puzzleElements = try throwableClosure()
				var pieces: [UIImageView] = []
				for row in 0 ..< numRows {
					for column in 0 ..< numColumns {
						let index = Int(row*numColumns+column)
						let num = pieceAray[index]

						let puzzleElement = puzzleElements[row][column]
						let position = puzzleElement.position
						let image = puzzleElement.image
						
						let piece = UIImageView(frame: CGRect(x: position.x, y: position.y, width: image.size.width, height: image.size.height))
						piece.contentMode = .scaleAspectFill
						NSLayoutConstraint.fixWidth(view: piece, constant: image.size.width)
						NSLayoutConstraint.fixHeight(view: piece, constant: image.size.height)

						piece.image = image
						piece.tag = num
						pieces.append(piece)

						let answerArea = UIView(frame: CGRect(x: 0, y: 0, width: bound.width*0.053, height: bound.width*0.053))
						answerArea.center = CGPoint(x: piece.center.x + movePointx, y: piece.center.y + movePointy)
						answerArea.backgroundColor = UIColor.clear
						self.answerAreaAray.append(answerArea)
						self.view.addSubview(answerArea)

						let movePieces: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.dragPieces))
						piece.addGestureRecognizer(movePieces)
						piece.isUserInteractionEnabled = true
					}
				}
				if numRows > 6 {
					let splited = pieces.shuffled().split()
					splited.first?.forEach { self.pieceStackView.addArrangedSubview($0) }
					splited.second?.forEach { self.pieceSecondStackView.addArrangedSubview($0) }
				} else {
					pieces.shuffled().forEach { self.pieceStackView.addArrangedSubview($0) }
				}

			} catch let error {
				debugPrint(error)
			}
		}
	}

	@objc
	func dragPieces(sender: UIPanGestureRecognizer) {
		guard let targetImg = sender.view else { return }
		let center: CGPoint

		if targetImg.superview is UIStackView {
			let center2 = scrollView.convert(targetImg.center, to: view)
			print("center2 \(center2)")
			switch targetImg.superview {
				case pieceStackView :
					center = CGPoint(x: center2.x+20, y: center2.y+20)
				case pieceSecondStackView:
					center = CGPoint(x: center2.x+70, y: center2.y+20)
				default:
					center = center2
			}
			print("center \(center)")
		} else {
			view.bringSubviewToFront(targetImg)
			center = targetImg.center
		}

		func freez() {
			targetImg.removeFromSuperview()
			view.addSubview(targetImg)
			targetImg.translatesAutoresizingMaskIntoConstraints = true
		}

		if sender.state == UIGestureRecognizer.State.ended {
			let answerView = answerAreaAray[targetImg.tag-1]

			if (answerView.frame.contains(center)) {
				freez()
				targetImg.center = CGPoint(x: answerView.center.x, y: answerView.center.y)
				targetImg.isUserInteractionEnabled = false
				correctCount += 1
				print(Int(correctCount))
				showFirework(puzzle: targetImg)
				if correctCount == input.difficulty.fieldSize*input.difficulty.fieldSize {
					output.finish()
				}
			} else {
				if previewView.frame.contains(center) {
					freez()
					playSounds(Sound.wrong.url)
					targetImg.center = center
				} else {
					pieceStackView.insertArrangedSubview(targetImg, at: 0)
				}
			}
		} else {
			movePiece(sender: sender, targetImg: targetImg)
		}
	}

	private func movePiece(sender: UIPanGestureRecognizer, targetImg: UIView) {
		let point: CGPoint = sender.translation(in: self.view)
		let movedPoint: CGPoint = CGPoint(x: targetImg.center.x + point.x, y: targetImg.center.y + point.y)
		targetImg.center = movedPoint
		sender.setTranslation(CGPoint.zero, in: self.view)
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
