//
//  ExtendedMainCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 10.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

protocol DidSelectRazdelAt {
    func goToRazdel(razdel: Int)
    func goToSerial(razdel: Int, title: String)
    func goToPreview(razdelId: Int, videoId: Int)
    func addVideoToFavorite(videoId: Int)
    func downloadVideo(video: Serial.Item, completion : @escaping (_ like : Bool) -> ())
    func present(title: String, actions: [UIAlertAction])
}

class ExtendedMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var serials: [MainContent] = []
    private var razdelNumber: Int = 0
    private var videosCell: Bool = false
    var delegate: DidSelectRazdelAt?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cells = [RazdelCollectionViewCell.self, MoreSerialsCollectionViewCell.self, VideoCollectionViewCell.self]
        collectionView.register(cells: cells)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureCell(content: [MainContent], razdelNumber: Int, videosCell: Bool) {
        self.serials = content
        self.razdelNumber = razdelNumber
        self.videosCell = videosCell
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
        collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
}

extension ExtendedMainCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let serials = serials[indexPath.row] as? RazdelVCModel.SerialItem {
                delegate?.goToSerial(razdel: serials.id, title: serials.name)
            } else if let video = serials[indexPath.row] as? Serial.Item {
                delegate?.goToPreview(razdelId: razdelNumber, videoId: video.id)
            }
        } else {
            delegate?.goToRazdel(razdel: razdelNumber)
        }
    }
}

extension ExtendedMainCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return serials.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if videosCell {
                let cell = collectionView.dequeueReusableCell(withCell: VideoCollectionViewCell.self, for: indexPath)
                if let serials = serials[indexPath.row] as? Serial.Item {
                    cell.configure(item: serials)
                    cell.delegate = self
                }
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withCell: RazdelCollectionViewCell.self, for: indexPath)
                if let serials = serials[indexPath.row] as? RazdelVCModel.SerialItem {
                    cell.configure(item: serials)
                }
                return cell
            }
        } else {
            let cell = collectionView.dequeueReusableCell(withCell: MoreSerialsCollectionViewCell.self, for: indexPath)
            return cell
        }
    }
}

extension ExtendedMainCollectionViewCell: SerialCellProtocol {
    func favClick(_ sender: Any) {
        if let cell = sender as? VideoCollectionViewCell, let idx = collectionView.indexPath(for: cell)?.row {
            guard let video = serials[idx] as? Serial.Item else { return }
            delegate?.addVideoToFavorite(videoId: video.id)
        }
    }
    
    func downloadClick(_ sender: Any) {
        if let cell = sender as? VideoCollectionViewCell, let idx = collectionView.indexPath(for: cell)?.row {
            guard let video = serials[idx] as? Serial.Item else { return }
            
            guard !cell.downloadBtn.isSelected else { return }
            
            let yes = UIAlertAction(title: "Скачать", style: .default, handler: { [weak self] (_) in
                self?.delegate?.downloadVideo(video: video) { action in
                    cell.downloadBtn.isSelected = action
                }
            })
            let no = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
            delegate?.present(title: "Скачать серию?", actions: [yes, no])
        }
    }
    
    func buttonClick(_ sender: Any) {
        
    }
}

extension ExtendedMainCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.height * 1.75, height: collectionView.bounds.height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        if section == 0 {
//            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20.0)
//        } else {
//            return .zero
//        }
//    }
}
