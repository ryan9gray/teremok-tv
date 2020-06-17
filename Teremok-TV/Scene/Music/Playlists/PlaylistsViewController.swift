//
//  PlaylistsViewController.swift
//  Teremok-TV
//
//  Created by Evgeny Ivanov on 17/03/2019.
//  Copyright (c) 2019 xmedia. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import AlamofireImage

protocol PlaylistsDisplayLogic: CommonDisplayLogic {
    func displayPlaylist(_ playlist: Playlist.Item) 
}

class PlaylistsViewController: MusicViewController, PlaylistsDisplayLogic {
    var modallyControllerRoutingLogic: CommonRoutingLogic? {
        get { return router }
    }
    var activityView: LottieHUD?

    var interactor: PlaylistsBusinessLogic?
    var router: (NSObjectProtocol & PlaylistsRoutingLogic & PlaylistsDataPassing & CommonRoutingLogic)?

    // MARK: Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        let viewController = self
        let interactor = PlaylistsInteractor()
        let presenter = PlaylistsPresenter()
        let router = PlaylistsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    @IBOutlet private var collectionView: UICollectionView!

    var currentIndex = Int()

    var playlist: Playlist.Item? {
        didSet {
            items = playlist?.tracks ?? []
        }
    }
    var items: [Playlist.Track] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    @IBOutlet private var albumPoster: PreviewImage!
    @IBOutlet private var albumLbl: UILabel!

    @IBAction func downloadAllClick(_ sender: Any) {

    }

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareUI()
        showPreloader()
        interactor?.getPlaylist()
        NotificationCenter.default.addObserver(self, selector: #selector(setSelected), name: .SwichTrack, object: nil)
    }

    func displayPlaylist(_ playlist: Playlist.Item) {
        guard !playlist.tracks.isEmpty else {
            self.present(errorString: "К сожалению, по вашему запросу ничего не найдено.") {
                self.masterRouter?.popChild()
            }
            return
        }
        hidePreloader()
        self.playlist = playlist
        setImage(url: playlist.imageUrl)
        albumLbl.text = playlist.albumTitle

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if let type = self.master?.type,
                case .online(idx: let idx, playlist: let response) = type,
                self.router?.dataStore?.albumId == response.id  {
                self.collectionView.selectItem(at: IndexPath(row: idx, section: 0), animated: true, scrollPosition: .top)
            }
        }
    }

    func setImage(url: String) {
        guard let downloadURL = URL(string: url) else { return }

        albumPoster.af.setImage(
            withURL: downloadURL,
            placeholderImage: #imageLiteral(resourceName: "icNowifi"),
            filter: nil,
            imageTransition: .crossDissolve(0.5),
            completion: nil)
    }

    private func prepareUI(){
        activityView = LottieHUD()
        collectionView.delegate = self
        collectionView.register(cells: [TrackCollectionViewCell.self])
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    @objc func setSelected(_ notification: NSNotification) {
        guard
            let index = notification.object as? Int,
            let info = notification.userInfo,
            let id = info["id"] as? Int,
            router?.dataStore?.albumId == id
        else { return }

        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredVertically)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .SwichTrack, object: nil)
    }
}
extension PlaylistsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        router?.playTrack(track: indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if let indexPaths = collectionView.indexPathsForSelectedItems, indexPaths.contains(indexPath) {
            collectionView.deselectItem(at: indexPath, animated: true)
            master?.pauseTrack()
            return false
        }
        return true
    }
}
extension PlaylistsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withCell: TrackCollectionViewCell.self, for: indexPath)
        let item = items[indexPath.row]
        cell.configurate(title: item.title, subtitle: item.subtitle)
        return cell
    }
}
extension PlaylistsViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 40.0)
    }
}
