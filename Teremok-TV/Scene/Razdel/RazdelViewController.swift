//
//  RazdelViewController.swift
//  Teremok-TV
//
//  Created by R9G on 02/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import Trackable

protocol RazdelDisplayLogic: CommonDisplayLogic, TrackableClass {
    func displaySerials(_ serials: [RazdelVCModel.SerialItem])
}

class RazdelViewController: AbstracViewController, RazdelDisplayLogic {
    var activityView: LottieHUD?
    
    var interactor: RazdelBusinessLogic?
    var router: (NSObjectProtocol & RazdelRoutingLogic & RazdelDataPassing & CommonRoutingLogic)?

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
        let interactor = RazdelInteractor()
        let presenter = RazdelPresenter()
        let router = RazdelRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle

    var serials: [RazdelVCModel.SerialItem] = []

    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var mainTitleView: MainTitleView!
    var cellWidth: CGFloat = 0
    let startTime = Date()

    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        let cells = [RazdelCollectionViewCell.self, LoadingCollectionViewCell.self]
        collectionView.register(cells: cells)
        prepareUI()
        setupTrackableChain(parent: analytics)
        
        mainTitleView.configureTitle(title: router?.dataStore?.razdelTitle ?? "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.interactor?.fetchSerials()
    }
    
    private func prepareUI(){
        activityView = LottieHUD()

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        cellWidth = self.view.bounds.width/3.2
        showPreloader()
    }

    func displaySerials(_ serials: [RazdelVCModel.SerialItem]){
        hidePreloader()

        self.serials.append(contentsOf: serials)
        guard !self.serials.isEmpty else {
            self.present(errorString: "Пусто") {
                self.masterRouter?.popChild()
            }
            return
        }
        collectionView.reloadData()
    }

    deinit {
        track(
            Events.Time.Razdel,
            trackedProperties: [Keys.Timer  ~>> NSDate().timeIntervalSince(startTime), Keys.Identifier ~>> router?.dataStore?.razdelId ?? 0]
        )
    }
}
extension RazdelViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.router?.navigateToSerial(number: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row == serials.count-1 {
            self.interactor?.fetchSerials()
        }
    }
}
extension RazdelViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serials.count + (self.interactor!.hasMore ? 1 : 0)//danger
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == serials.count {
            let cell = collectionView.dequeueReusableCell(withCell: LoadingCollectionViewCell.self, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withCell: RazdelCollectionViewCell.self, for: indexPath)
        let serial = serials[indexPath.row]
        cell.configure(item: serial)
        cell.delegate = self
        
        return cell
    }
    
}

extension RazdelViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}

extension RazdelViewController: ButtonCellProtocol {
    
    func buttonClick(_ sender: Any) {
        if let cell = sender as? RazdelCollectionViewCell {
            self.router?.navigateDescription(item: cell.item)
        }
    }
}

extension RazdelViewController: DescriptionVCProtocol {

    func toWatch(_ sender: Any) {
        if let vc = sender as? RazdelDescriptionViewController, let item = vc.item, let dx = self.serials.firstIndex(of: item) {
            self.router?.navigateToSerial(number: dx)
        }
    }
}
