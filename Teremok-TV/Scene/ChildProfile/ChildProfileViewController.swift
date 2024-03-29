//
//  ChildProfileViewController.swift
//  Teremok-TV
//
//  Created by R9G on 12/10/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ChildProfileDisplayLogic: CommonDisplayLogic {
    func displayFavorites(items: [PreviewModel])
    func displayProfile()
    func displayAchieves(_ items: String)

}

class ChildProfileViewController: AbstracViewController, ChildProfileDisplayLogic {
    var activityView: LottieHUD?
    
    var interactor: ChildProfileBusinessLogic?
    var router: (NSObjectProtocol & ChildProfileRoutingLogic & ChildProfileDataPassing & CommonRoutingLogic)?

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
    @IBOutlet private var nameLbl: UILabel!
    
    private func setup() {
        let viewController = self
        let interactor = ChildProfileInteractor()
        let presenter = ChildProfilePresenter()
        let router = ChildProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: View lifecycle

    @IBOutlet private var collectionView: UICollectionView!
    var favorites: [PreviewModel] = []
    var cellWidth: CGFloat = 0
    @IBOutlet private var avatar: AvatarButton!
    @IBOutlet private var achCountLbl: UILabel!
    
    @IBAction func avatarClick(_ sender: Any) {
        router?.reductProfile()
    }
    @IBAction func pancilClick(_ sender: Any) {
        router?.reductProfile()
    }
    
    @IBOutlet private var headerLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        cellWidth = self.view.bounds.width/4
        let cells = [PreviewCollectionViewCell.self, LoadingCollectionViewCell.self]
        collectionView.register(cells: cells)
        interactor?.fetchChild()
    }
    
    func displayFavorites(items: [PreviewModel]){
        favorites = items
        collectionView.reloadData()
    }

    func displayAchieves(_ items: String){
        achCountLbl.text = items
    }

    func displayProfile(){
        guard let child = Profile.currentChild else { return }
        displayChild(child)
    }
    
    func displayChild(_ child: Child){
        avatar.setAvatar(linktoLoad: child.pic ?? "")
        nameLbl.text = child.name ?? "-"
    }
}

extension ChildProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.navigateToPreview(number: indexPath.row)
    }
}
extension ChildProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        headerLbl.isHidden = favorites.isEmpty
        return favorites.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withCell: PreviewCollectionViewCell.self, for: indexPath)
        switch favorites[indexPath.row].imageLink {
            case .data(let data):
                cell.configure(data: data)
            case .url(let url):
                cell.configure(link: url?.absoluteString ?? "")
        }
        return cell
    }
}

extension ChildProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
