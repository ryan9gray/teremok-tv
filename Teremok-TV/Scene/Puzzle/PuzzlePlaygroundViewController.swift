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
		let image: UIImage? = input.image!.resizeImageUsingVImage(previewView.frame.size)
		previewView.image = image
		let numRows = input.difficulty.fieldSize
		let numColumns = input.difficulty.fieldSize

		var pieceAray: [Int] = []

		for i in 0...numColumns*numRows {
			pieceAray.append(i+1)
		}
		pieceStackView.subviews.forEach { $0.removeFromSuperview() }

		let bound = previewView.bounds
		let movePointx:CGFloat = self.previewView.frame.origin.x
		let movePointy:CGFloat = self.previewView.frame.origin.y
		let puzzleMaker = PuzzleMaker(image: image!, numRows: numRows, numColumns: numColumns)
		puzzleMaker.generatePuzzles { (throwableClosure) in
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
						//NSLayoutConstraint.fixWidth(view: pieces, constant: image.size.width)
						//NSLayoutConstraint.fixHeight(view: pieces, constant: image.size.height)

						pieces.image = image
						pieces.tag = num
						self.view.addSubview(pieces)
						//self.pieceStackView.addArrangedSubview(pieces)

						let answerArea = UIView(frame: CGRect(x: 0, y: 0, width: self.previewView.frame.width*0.053, height: self.previewView.frame.width*0.053))
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
	func dragPieces(sender:UIPanGestureRecognizer) {
		self.view.bringSubviewToFront(sender.view!)

		if sender.state == UIGestureRecognizer.State.ended {
			let targetImg: UIView = sender.view!

			for _ in 0..<answerAreaAray.count {

				let answerView = answerAreaAray[targetImg.tag-1]

				if (answerView.frame.contains(targetImg.center)) {
					targetImg.center = CGPoint(x: answerView.center.x, y: answerView.center.y)
					targetImg.isUserInteractionEnabled = false
					correctCount += 1
					print(Int(correctCount))
//					if correctCount == input.difficulty.fieldSize^2 {
//						print("Congratulations!")
//					} else {
//						break
//					}
				}
			}
		} else {
			let point: CGPoint = sender.translation(in: self.view)
			let movedPoint: CGPoint = CGPoint(x: sender.view!.center.x + point.x, y: sender.view!.center.y + point.y)
			sender.view!.center = movedPoint
			sender.setTranslation(CGPoint.zero, in: self.view)
			//print(point)
		}

	}
//	@objc func dragPieces(sender: UIPanGestureRecognizer) {
//		guard let targetImg = sender.view else { return }
//		targetImg.removeFromSuperview()
//		view.addSubview(targetImg)
//		view.bringSubviewToFront(targetImg)
//		let point: CGPoint = sender.translation(in: view)
//
//		print(point)
//
//		switch sender.state {
//			case .began:
//				break
//			case .ended:
////				if !previewView.frame.contains(point) {
////					pieceStackView.insertArrangedSubview(targetImg, at: 0)
////					return
////				} else {
////					targetImg.removeFromSuperview()
////					view.addSubview(targetImg)
////					view.bringSubviewToFront(targetImg)
////				}
//				let answerView = answerAreaAray[targetImg.tag-1]
//
//				for _ in 0..<answerAreaAray.count {
//
//
//					if (answerView.frame.contains(targetImg.center)) {
//
//						targetImg.center = CGPoint(x: answerView.center.x, y: answerView.center.y)
//						targetImg.isUserInteractionEnabled = false
//						correctCount += 1
//						print(Int(correctCount))
//						if correctCount == input.difficulty.fieldSize^2 {
//							print("Congratulations!")
//						} else {
//							break
//						}
//					}
//			}
//			default:
//				let movedPoint: CGPoint = CGPoint(x: sender.view!.center.x + point.x, y: sender.view!.center.y + point.y)
//				sender.view!.center = movedPoint
//				sender.setTranslation(CGPoint.zero, in: self.view)
//		}
//	}

	func trimmingImage(_ image: UIImage, trimmingSize: CGSize) -> UIImage {
		let imgRef = image.cgImage?.cropping(to: CGRect(x: 0, y: 0, width: trimmingSize.width, height: trimmingSize.height))
		let trimImage = UIImage(cgImage: imgRef!, scale: image.scale, orientation: image.imageOrientation)

		return trimImage

	}
}
