//
//  StoreViewController.swift
//  Teremok-TV
//
//  Created by R9G on 04/12/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Trackable

protocol StoreDisplayLogic: CommonDisplayLogic, TrackableClass {
    func displayPurchase()
    func successPurchase()
}

class StoreViewController: AbstracViewController, StoreDisplayLogic, UITextViewDelegate{
    var activityView: LottieHUD?
    var interactor: StoreBusinessLogic?
    var router: (NSObjectProtocol & StoreRoutingLogic & StoreDataPassing & CommonRoutingLogic)?
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: Setup

    private func setup() {
        let viewController = self
        let interactor = StoreInteractor()
        let presenter = StorePresenter()
        let router = StoreRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    @IBOutlet private var collectionView: UICollectionView!

	let havePromo = PromoWorker.havePromo

	let subscriptions: [RegisteredPurchase] = {
		PromoWorker.havePromo
			? [.promo3month, .game, .music, .video]
			: [.game, .music, .video]
	}()

    let profile = Profile.current

    override func viewDidLoad() {
        super.viewDidLoad()

		PromoWorker.setDate()
        activityView = LottieHUD()
        collectionView.delegate = self
        collectionView.dataSource = self
		let cells = [
			SubscriptionCollectionViewCell.self,
			StoreCollectionViewCell.self,
			LoadingCollectionViewCell.self,
			SubscriptionPromoCollectionViewCell.self
		]
        collectionView.register(cells: cells)
        collectionView.reloadData()
        setupTrackableChain(parent: analytics)
    }

    func restoreClick() {
        showPreloader()
        interactor?.restore()
        track(Events.Store.RestoreTap)
    }
    
    func purchase(sub: RegisteredPurchase){
        showPreloader()
        interactor?.buy(sub: sub)
        track(Events.Store.PurchaseTap, trackedProperties: [Keys.Identifier ~>> sub.rawValue])
    }

    func displayPurchase(){
        hidePreloader()
    }

    func successPurchase() {
        track(Events.Store.Purchased)
        router?.navigateAfterPurchase()
    }
}

extension StoreViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return havePromo ? 5 : 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withCell: StoreCollectionViewCell.self, for: indexPath)
            cell.action = { [weak self] in
				self?.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .left, animated: true)
            }
            return cell
        } else {
			let subscription = subscriptions[(indexPath.row - 1)]
			switch subscription {
				case .promo3month:
					let cell = collectionView.dequeueReusableCell(withCell: SubscriptionPromoCollectionViewCell.self, for: indexPath)
					cell.input = SubscriptionPromoCollectionViewCell.Input(updatePrice: interactor!.fetchProduct)
					cell.output = SubscriptionPromoCollectionViewCell.Output(
						restoreAction: { [weak self] in
							self?.restoreClick()
						},
						purchaseAction: { [weak self] in
							self?.purchase(sub: subscription)
						}
					)
					cell.configurate(
						sub: subscription,
						have: profile?.currentPremium() == subscription.premium
					)
					return cell
				default:
					let cell = collectionView.dequeueReusableCell(withCell: SubscriptionCollectionViewCell.self, for: indexPath)
					cell.input = SubscriptionCollectionViewCell.Input(updatePrice: interactor!.fetchProduct)
					cell.output = SubscriptionCollectionViewCell.Output(
						restoreAction: { [weak self] in
							self?.restoreClick()
						},
						purchaseAction: { [weak self] in
							self?.purchase(sub: subscription)
						}
					)
					cell.configurate(
						sub: subscription,
						have: profile?.currentPremium() == subscription.premium
					)
					return cell
			}
        }
    }
}
extension StoreViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.bounds.height
		if havePromo, indexPath.row == 1 {
			return CGSize(width: collectionView.bounds.width * 0.7, height: height)
		}
        if indexPath.row == 0 {
            return CGSize(width: collectionView.bounds.width * 0.8, height: height)

        } else {
            return CGSize(width: height / 0.9, height: height)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		20
    }
}
