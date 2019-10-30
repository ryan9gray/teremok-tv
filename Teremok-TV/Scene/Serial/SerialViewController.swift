//
//  SerialViewController.swift
//  Teremok-TV
//
//  Created by R9G on 06/09/2018.
//  Copyright (c) 2018 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol SerialDisplayLogic: CommonDisplayLogic {
    func displaySerials(_ serials: [Serial.Item])

}

class SerialViewController: AbstracViewController, SerialDisplayLogic {
    var activityView: LottieHUD?
    
    
    var interactor: SerialBusinessLogic?
    var router: (NSObjectProtocol & SerialRoutingLogic & SerialDataPassing & CommonRoutingLogic)?

    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    
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
        let interactor = SerialInteractor()
        let presenter = SerialPresenter()
        let router = SerialRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    // MARK: View lifecycle

    @IBOutlet private var collectionView: UICollectionView!
    
    var serials: [Serial.Item] = []
    
    
    var cellWidth: CGFloat = 0
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        let cells = [VideoCollectionViewCell.self, LoadingCollectionViewCell.self]
        collectionView.register(cells: cells)
        prepareUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
       self.interactor?.fetchVideos()
    }

    private func prepareUI(){
        activityView = LottieHUD()

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        cellWidth = self.view.bounds.width/3.2
        showPreloader()
    }
    
    func displaySerials(_ serials: [Serial.Item]){        
        hidePreloader()

        self.serials.append(contentsOf: serials)
        
        guard !self.serials.isEmpty else {
            self.present(errorString: "К сожалению, по вашему запросу ничего не найдено.") {
                self.masterRouter?.popChild()
            }
            return
        }
        collectionView.reloadData()
    }
}

extension SerialViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.navigateToPreview(number: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath){
        if indexPath.row == serials.count-1 {
            interactor?.fetchVideos()
        }
    }
}
extension SerialViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return serials.count + (interactor!.hasMore ? 1 : 0)//danger
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == serials.count {
            let cell = collectionView.dequeueReusableCell(withCell: LoadingCollectionViewCell.self, for: indexPath)
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withCell: VideoCollectionViewCell.self, for: indexPath)
        cell.cloudImageView.image = Cloud.clouds.randomElement()
        let serial = serials[indexPath.row]
        cell.configure(item: serial)
    
        cell.delegate = self
        return cell
    }
    
}
extension SerialViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: collectionView.bounds.height)
    }
}
extension SerialViewController: SerialCellProtocol {
    func favClick(_ sender: Any) {
        if let cell = sender as? VideoCollectionViewCell, let idx = collectionView.indexPath(for: cell)?.row {
            self.interactor?.addToFav(idx: idx)
            self.serials[idx].isLikeMe.toggle()
        }
    }
    
    func downloadClick(_ sender: Any) {
        if let cell = sender as? VideoCollectionViewCell, let idx = collectionView.indexPath(for: cell)?.row {
            
            guard !cell.downloadBtn.isSelected else { return }
            
            let yes = UIAlertAction(title: "Скачать", style: .default, handler: { (_) in
                self.interactor?.downloadVideo(idx: idx) { action in
                    cell.downloadBtn.isSelected = action
                }
            })
            let no = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
            self.present(title: "Скачать серию?", actions: [yes, no], completion: nil)
        }
    }
    
    func buttonClick(_ sender: Any) {
        if let cell = sender as? VideoCollectionViewCell {
            self.router?.navigateDescription(item: cell.item)
        }
    }
}

extension SerialViewController: DescriptionSerialVCProtocol {
    func forward(_ sender: Any) {
        if let vc = sender as? SerialDescriptionViewController, let item = vc.item, let dx = self.serials.firstIndex(of: item), dx != self.serials.endIndex {
            let nxtDx = self.serials.index(after: dx)
            vc.item = self.serials[nxtDx]
            vc.reload()
        }
    }
    
    func previous(_ sender: Any) {
        if let vc = sender as? SerialDescriptionViewController, let item = vc.item, let dx = self.serials.firstIndex(of: item), dx != self.serials.startIndex {
            let nxtDx = self.serials.index(before: dx)
            vc.item = self.serials[nxtDx]
            vc.reload()
        }
    }
    
    func toWatch(_ sender: Any) {
        if let vc = sender as? SerialDescriptionViewController, let item = vc.item, let dx = self.serials.firstIndex(of: item) {
            self.router?.navigateToPreview(number: dx)
        }
    }  
}
