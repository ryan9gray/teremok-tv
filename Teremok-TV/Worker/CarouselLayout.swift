//
//  CarouselLayout.swift
//  CarouselCollectionLayout
//
//  Created by Bartosz Kamiński on 11/06/2018.
//  Copyright © 2018 Bartosz Kamiński. All rights reserved.
//

import UIKit
import AVFoundation

class CarouselLayout: UICollectionViewLayout {
    
    // MARK: - Public Properties
    
    override var collectionViewContentSize: CGSize {
		let leftmostEdge = cachedItemsAttributes.values.map { $0.frame.minX }.min() ?? 0
		let rightmostEdge = cachedItemsAttributes.values.map { $0.frame.maxX }.max() ?? 0
        return CGSize(width: rightmostEdge - leftmostEdge, height: itemSize.height)
    }
    
    // MARK: - Private Properties

    private var cachedItemsAttributes: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    private var itemSize: CGSize {
        guard let collectionView = collectionView else { return CGSize(width: 0, height: 0) }

        return CGSize(width: collectionView.bounds.height * 1.75, height: collectionView.bounds.height)
    }
    let generator = UISelectionFeedbackGenerator()
    var audioPlayer: AVAudioPlayer?
    let pianoSound = URL(fileURLWithPath: Bundle.main.path(forResource: "swipe_card_sound", ofType: "wav")!)

    private let spacing: CGFloat = 20
	private let spacingWhenFocused: CGFloat = 20

	private var continuousFocusedIndex: CGFloat {
		guard let collectionView = collectionView else { return 0 }

		let offset = collectionView.bounds.width / 2 + collectionView.contentOffset.x - itemSize.width / 2
		return offset / (itemSize.width + spacing)
	}
    
    // MARK: - Public Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        //guard let collectionView = self.collectionView else { return }
        generator.prepare()
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: pianoSound)
        } catch {
            // couldn't load file :(
        }
    }

    private func playSound(){
        audioPlayer?.play()
    }
    
    override open func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else { return }
        
        updateInsets()
        guard cachedItemsAttributes.isEmpty else { return }
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
		for section in 0...collectionView.numberOfSections-1 {
			let itemsCount = collectionView.numberOfItems(inSection: section)
			for item in 0..<itemsCount {
				let indexPath = IndexPath(item: item, section: section)
				cachedItemsAttributes[indexPath] = createAttributesForItem(at: indexPath)
			}
		}
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cachedItemsAttributes
			.map { $0.value }
			.filter { $0.frame.intersects(rect) }
			.map { self.shiftedAttributes(from: $0) }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        let collectionViewMidX: CGFloat = collectionView.bounds.size.width / 2
		guard let closestAttribute = findClosestAttributes(toXPosition: proposedContentOffset.x + collectionViewMidX) else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset) }
        generator.selectionChanged()
        playSound()
        return CGPoint(x: closestAttribute.center.x - collectionViewMidX, y: proposedContentOffset.y)
    }

    // MARK: - Invalidate layout
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if newBounds.size != collectionView?.bounds.size { cachedItemsAttributes.removeAll() }
        return true
    }
    
    override func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        if context.invalidateDataSourceCounts { cachedItemsAttributes.removeAll() }
        super.invalidateLayout(with: context)
    }
    
    // MARK: - Items
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = cachedItemsAttributes[indexPath] else { fatalError("No attributes cached") }
        return shiftedAttributes(from: attributes)
    }
    
    private func createAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        guard let collectionView = collectionView else { return nil }
		let originX: CGFloat
		if indexPath.section > 0 {
			var count = 0
			for section in 0...indexPath.section-1 {
				count += collectionView.numberOfItems(inSection: section)
			}
			originX = CGFloat(indexPath.row + count)
		} else {
			originX = CGFloat(indexPath.item)
		}
        attributes.frame.size = itemSize
        attributes.frame.origin.y = (collectionView.bounds.height - itemSize.height) / 2
		attributes.frame.origin.x = originX * (itemSize.width + spacing)
        return attributes
    }
    
    private func shiftedAttributes(from attributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        guard let attributes = attributes.copy() as? UICollectionViewLayoutAttributes else { fatalError("Couldn't copy attributes") }
		let roundedFocusedIndex = round(continuousFocusedIndex)
        guard attributes.indexPath.item != Int(roundedFocusedIndex) else { return attributes }
		let shiftArea = (roundedFocusedIndex - 0.5)...(roundedFocusedIndex + 0.5)
		let distanceToClosestIdentityPoint = min(abs(continuousFocusedIndex - shiftArea.lowerBound), abs(continuousFocusedIndex - shiftArea.upperBound))
		let normalizedShiftFactor = distanceToClosestIdentityPoint * 2
        let translation = (spacingWhenFocused - spacing) * normalizedShiftFactor
        let translationDirection: CGFloat = attributes.indexPath.item < Int(roundedFocusedIndex) ? -1 : 1
        attributes.transform = CGAffineTransform(translationX: translationDirection * translation, y: 0)
        return attributes
    }

    // MARK: - Private Methods
    
    private func findClosestAttributes(toXPosition xPosition: CGFloat) -> UICollectionViewLayoutAttributes? {
		guard let collectionView = collectionView else { return nil }
		let searchRect = CGRect(
			x: xPosition - collectionView.bounds.width, y: collectionView.bounds.minY,
			width: collectionView.bounds.width * 2, height: collectionView.bounds.height
		)
        return layoutAttributesForElements(in: searchRect)?.min(by: { abs($0.center.x - xPosition) < abs($1.center.x - xPosition) })
    }
    
    private func updateInsets() {
        guard let collectionView = collectionView else { return }
        collectionView.contentInset.left = (collectionView.bounds.size.width - itemSize.width) / 2
        collectionView.contentInset.right = (collectionView.bounds.size.width - itemSize.width) / 2
    }
}
