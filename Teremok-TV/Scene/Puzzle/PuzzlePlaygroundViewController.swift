//
//  PuzzlePlaygroundViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 22.03.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class PuzzlePlaygroundViewController: UIViewController {
	@IBOutlet private var previewView: UIImageView!

	var input: Input!
	var output: Output!

	struct Output {
		let finish: () -> Void
	}

	struct Input {
		var image: UIImage?
		let difficulty: PuzzleGameFlow.Game.Difficulty
	}
	var tapCount: Int = 0

	var correctCount = 0
	var answerAreaAray:[UIView] = []
	var height: CGFloat = 300
	let baseImg = UIImageView()
	let beforeImg = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		createPuzzle()
	}

	private func createPuzzle() {
		var image: UIImage? = input.image

		let numRows = input.difficulty.fieldSize
		let numColumns = input.difficulty.fieldSize

		var pieceAray:[Int] = []

		for i in 0...numColumns*numRows {
			pieceAray.append(i+1)
		}

		// Resize image for given device.
		UIGraphicsBeginImageContextWithOptions(CGSize(width: baseImg.frame.width, height: baseImg.frame.width), _: false, _: 0.0)
		image!.draw(in: CGRect(x: 0, y: 0, width: baseImg.frame.width, height: baseImg.frame.width))
		image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		let bound = view.bounds
		// Make puzzle.
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
						pieces.image = image
						pieces.tag = num
						self.view.addSubview(pieces)

						let movePointx:CGFloat = self.baseImg.center.x - self.beforeImg.center.x
						let movePointy:CGFloat = self.baseImg.center.y - self.beforeImg.center.y

						let answerArea = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width*0.053, height: self.view.frame.width*0.053))
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

						let movePieces:UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.dragPieces))
						pieces.addGestureRecognizer(movePieces)
						pieces.isUserInteractionEnabled = true
					}
				}

			} catch let error {

				debugPrint(error)
			}

		}
	}

	@objc func dragPieces(sender: UIPanGestureRecognizer) {
		view.bringSubviewToFront(sender.view!)

		if sender.state == UIGestureRecognizer.State.ended {
			let targetImg:UIView = sender.view!

			for _ in 0..<answerAreaAray.count {

				let answerView = answerAreaAray[targetImg.tag-1]

				if (answerView.frame.contains(targetImg.center)) {

					targetImg.center = CGPoint(x: answerView.center.x, y: answerView.center.y)
					targetImg.isUserInteractionEnabled = false
					correctCount += 1
					print(Int(correctCount))
					if correctCount == 16 {
						print("Congratulations!")
					} else {
						break
					}
				}
			}
		} else {
			let point: CGPoint = sender.translation(in: self.view)
			let movedPoint: CGPoint = CGPoint(x: sender.view!.center.x + point.x, y: sender.view!.center.y + point.y)
			sender.view!.center = movedPoint
			sender.setTranslation(CGPoint.zero, in: self.view)
		}
	}

	func trimmingImage(_ image: UIImage, trimmingArea: CGRect) -> UIImage {
		let imgRef = image.cgImage?.cropping(to: trimmingArea)
		let trimImage = UIImage(cgImage: imgRef!, scale: image.scale, orientation: image.imageOrientation)

		return trimImage

	}
}
