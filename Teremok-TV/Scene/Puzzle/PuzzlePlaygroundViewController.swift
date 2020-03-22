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
	var answerAreaAray:[UIView] = []


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
				for row in 0 ..< numRows {
					for column in 0 ..< numColumns {
						let index = Int(row*numColumns+column)
						let num = pieceAray[index]

						let puzzleElement = puzzleElements[row][column]
						let position = puzzleElement.position
						let image = puzzleElement.image
						
						let pieces = UIImageView(frame: CGRect(x: position.x, y: position.y, width: image.size.width, height: image.size.height))
						pieces.contentMode = .scaleAspectFill
						NSLayoutConstraint.fixWidth(view: pieces, constant: image.size.width)
						NSLayoutConstraint.fixHeight(view: pieces, constant: image.size.height)

						pieces.image = image
						pieces.tag = num
						//self.view.addSubview(pieces)
						self.pieceStackView.addArrangedSubview(pieces)

						let answerArea = UIView(frame: CGRect(x: 0, y: 0, width: bound.width*0.053, height: bound.width*0.053))
						answerArea.center = CGPoint(x: pieces.center.x + movePointx, y: pieces.center.y + movePointy)
						answerArea.backgroundColor = UIColor.clear
						self.answerAreaAray.append(answerArea)
						self.view.addSubview(answerArea)

						let yoko = Int(arc4random_uniform(UInt32(bound.width*0.7)))
						let tate = Int(arc4random_uniform(UInt32(bound.height))/3)

						var point:CGPoint = pieces.center
						point.x = CGFloat(yoko)
						point.y = CGFloat(tate)
						pieces.center = CGPoint(x: point.x + bound.width*0.15, y: point.y + bound.height*0.5)

						let movePieces: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.dragPieces))
						pieces.addGestureRecognizer(movePieces)
						pieces.isUserInteractionEnabled = true
					}
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
			center = CGPoint(x: center2.x+20, y: center2.y+20)
		} else {
			view.bringSubviewToFront(targetImg)
			center = targetImg.center
		}


		print("center \(center)")
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
				if correctCount == input.difficulty.fieldSize^2 {
					print("Congratulations!")
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
