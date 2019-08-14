//
//  FavViewController.swift
//  Teremok-TV
//
//  Created by R9G on 14/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FavDisplayLogic: CommonDisplayLogic {
    func display(fav: [Fav.Item])
    func display(saved: [Fav.Item])
}

class FavViewController: AbstracViewController, FavDisplayLogic {
    var activityView: LottieHUD?
    var interactor: FavBusinessLogic?
    var router: (NSObjectProtocol & FavRoutingLogic & FavDataPassing)?

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
        let interactor = FavInteractor()
        let presenter = FavPresenter()
        let router = FavRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: Routing

    @IBOutlet private var tableView: UITableView!
    // MARK: View lifecycle

    var fav: [Fav.Item] = []
    var saved: [Fav.Item] = []
    
    var cellWidth: CGFloat = 0
    var storedOffsetsFav = [Int: CGFloat]()
    var storedOffsetsSaved = [Int: CGFloat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        showPreloader()
        interactor?.fetchFav()
    }

    func prepareUI(){
        NotificationCenter.default.post(name: .FavBadge, object: nil, userInfo: ["Fav": 0])
        activityView = LottieHUD()
        
        cellWidth = self.view.bounds.width/4
        tableView.register(cells: [FavTableViewCell.self])
        tableView.register(headerFooterView: FavTableViewHeader.self)
        tableView.dataSource = self
        tableView.delegate = self
    }
    // MARK: Display

    func display(fav: [Fav.Item]) {
        hidePreloader()
        self.fav.append(contentsOf: fav)
        reloadData()
    }
    
    func display(saved: [Fav.Item]) {
        hidePreloader()
        self.saved = saved
        reloadData()
    }
    
    func reloadData(){
        tableView.reloadData()
    }
}
extension FavViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard Profile.current?.premium ?? false else {
            present(errorString: Main.Messages.accessPremium, completion: nil)
            return
        }

        switch collectionView.tag {
        case 0:
            self.router?.navigateToFavPreview(number: indexPath.row)
        case 1:
            self.router?.navigateToSavedPreview(number: indexPath.row)
        default:
            break
        }
    }
}

extension FavViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if (section == 0 && fav.count > 0) || (section == 1 && saved.count > 0){
            let identifier = String(describing: FavTableViewHeader.self)
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? FavTableViewHeader, let favSection = Fav.Section.allCases[safe: section] else { return nil }
            header.configure(image: favSection.image, title: favSection.name)
            return header
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
  
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {

        return 40.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
//        if fav.count > 0, saved.count > 0 {
//            return 2
//        }
//        else {
//            return 1
//        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, fav.count == 0 {
            return 0
        }
        if section == 1, saved.count == 0 {
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withCell: FavTableViewCell.self, for: indexPath)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? FavTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(self, forRow: indexPath.section)
        if indexPath.section == 0{
            tableViewCell.collectionViewOffset = storedOffsetsFav[indexPath.row] ?? 0
        } else if indexPath.section == 1{
            tableViewCell.collectionViewOffset = storedOffsetsSaved[indexPath.row] ?? 0
        }
        
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let tableViewCell = cell as? FavTableViewCell else { return }
        if indexPath.section == 0{
            storedOffsetsFav[indexPath.row] = tableViewCell.collectionViewOffset
        } else if indexPath.section == 1{
            storedOffsetsSaved[indexPath.row] = tableViewCell.collectionViewOffset
        }
        
    }
}
extension FavViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 0:
            return fav.count
        case 1:
            return saved.count
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withCell: FavCollectionViewCell.self, for: indexPath)
        cell.delegate = self
        if collectionView.tag == 0 {
            cell.configure(url: fav[indexPath.row].imageUrl)
        }
        if collectionView.tag == 1 {
            cell.configure(url: saved[indexPath.row].imageUrl)
        }
        cell.ip = IndexPath(row: indexPath.row, section: collectionView.tag)
        return cell
    }
}
extension FavViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
extension FavViewController: ButtonWithIndexPath {
    
    func clickOn(indexPath: IndexPath) {
        
        let yes = UIAlertAction(title: "Удалить", style: .default, handler: { (_) in
            switch indexPath.section {
            case 0:
                self.fav.removeAll()
                self.interactor?.unLikeVideo(idx: indexPath.row)
            case 1:
                self.saved.removeAll()
                self.interactor?.deleteLocalVideo(idx: indexPath.row)
            default:
                break
            }
        })
        let no = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
        self.present(title: "Удалить серию?", actions: [yes, no], completion: nil)
   
    }
}
