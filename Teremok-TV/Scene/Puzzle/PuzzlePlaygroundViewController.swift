//
//  PuzzlePlaygroundViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class PuzzlePlaygroundViewController: GameViewController {
	@IBOutlet private var previewView: UIImageView!
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var pieceStackView: UIStackView!

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


    override func viewDidLoad() {
        super.viewDidLoad()

	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		createPuzzle()
	}

	private func createPuzzle() {
		guard let image = input.image?.resizeImageUsingVImage(previewView.frame.size) else { return }

		previewView.image = image
		let numRows = input.difficulty.fieldSize
		let numColumns = input.difficulty.fieldSize

		var pieceAray: [Int] = []

		for i in 0...numColumns*numRows {
			pieceAray.append(i+1)
		}
		pieceStackView.subviews.forEach { $0.removeFromSuperview() }

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
				pieces.shuffled().forEach { self.pieceStackView.addArrangedSubview($0) }
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
			center = CGPoint(x: center2.x+20, y: center2.y+20)
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
				if correctCount == input.difficulty.fieldSize*input.difficulty.fieldSize {
					output.finish()
				}
			} else {
				if previewView.frame.contains(center) {
					freez()
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
}
