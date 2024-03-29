//
//  AchievesViewController.swift
//  Teremok-TV
//
//  Created by R9G on 27/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AchievesDisplayLogic: CommonDisplayLogic {
    func displayAchieves(_ items: [Achieves.Achievement])
}

class AchievesViewController: AbstracViewController, AchievesDisplayLogic {
    var activityView: LottieHUD?
    
    var interactor: AchievesBusinessLogic?
    var router: (NSObjectProtocol & AchievesRoutingLogic & AchievesDataPassing & CommonRoutingLogic)?
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
        let interactor = AchievesInteractor()
        let presenter = AchievesPresenter()
        let router = AchievesRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }

    // MARK: View lifecycle

    var cellWidth: CGFloat = 0
    var achieves: [Achieves.Achievement] = []
    
    @IBOutlet private var collectionView: UICollectionView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        //NotificationCenter.default.post(name: .FavBadge, object: nil, userInfo: ["Ach": 0])

        self.interactor?.fetchAchievements()
    }
    

    // MARK: Do something
    func prepareUI(){
        NotificationCenter.default.post(name: .AchievmentBadge, object: nil, userInfo: ["Ach": 0])
        collectionView.delegate = self
        cellWidth = self.view.bounds.width/4
        let cells = [AchieveCollectionViewCell.self, LoadingCollectionViewCell.self]
        collectionView.register(cells: cells)
    }
    
    func displayAchieves(_ items: [Achieves.Achievement]){
        achieves.append(contentsOf: items)
        collectionView.reloadData()
    }
    
}
extension AchievesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
}
extension AchievesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return achieves.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withCell: AchieveCollectionViewCell.self, for: indexPath)
        cell.configure(achieves[indexPath.row])
        
        return cell
    }
    
}
extension AchievesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
