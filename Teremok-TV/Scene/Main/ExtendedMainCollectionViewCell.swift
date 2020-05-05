//
//  ExtendedMainCollectionViewCell.swift
//  Teremok-TV
//
//  Created by Виктор Пузаков on 10.04.2020.
//  Copyright © 2020 xmedia. All rights reserved.
//

import UIKit

class ExtendedMainCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    private var serials: [MainContent] = []
    private var razdelNumber: Int = 0
    private var videosCell: Bool = false
    var goToRazdel: ((_ razdel: Int) -> ())?
    var addVideoToFavorite: ((_ videoId: Int) -> ())?
    var goToSerial: ((_ razdel: Int, _ title: String) -> ())?
    var goToPreview: ((_ razdelId: Int, _ videoId: Int) -> ())?
    var downloadVideo: ((_ video: Serial.Item, _ complition: @escaping (_ like : Bool) -> ())->())?
    var downloadVideoActions: ((_ actions: [UIAlertAction]) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let cells = [RazdelCollectionViewCell.self, MoreSerialsCollectionViewCell.self, VideoCollectionViewCell.self]
        collectionView.register(cells: cells)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        configureLayout()
    }
    
    func configureCell(content: [MainContent], razdelNumber: Int, videosCell: Bool, wasAnimated: Bool) {
        self.serials = content
        self.razdelNumber = razdelNumber
        self.videosCell = videosCell
        if wasAnimated {
            minimumSpacingAnimation()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureLayout()
        collectionView.reloadData()
        collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    private func configureLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        layout.itemSize = CGSize(width: self.frame.height * 1.75, height: self.frame.height)
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        layout.minimumLineSpacing = -self.frame.height * 1.75 + 10
        collectionView.collectionViewLayout = layout
    }
    
    func minimumSpacingAnimation(duration: TimeInterval = 0.0) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        layout.itemSize = CGSize(width: self.frame.height * 1.75, height: self.frame.height)
        layout.minimumInteritemSpacing = 0.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        layout.minimumLineSpacing = 20.0
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.collectionView.setCollectionViewLayout(layout, animated: true)
        }) { [weak self] (result) in
            self?.collectionView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        }
    }
}

extension ExtendedMainCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let serial = serials[indexPath.row] as? RazdelVCModel.SerialItem {
                goToSerial?(serial.id, serial.name)
            } else if let video = serials[indexPath.row] as? Serial.Item {
                goToPreview?(razdelNumber, video.id)
            }
        } else {
            goToRazdel?(razdelNumber)
        }
    }
}

extension ExtendedMainCollectionViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 10
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
            addVideoToFavorite?(video.id)
        }
    }
    
    func downloadClick(_ sender: Any) {
        if let cell = sender as? VideoCollectionViewCell, let idx = collectionView.indexPath(for: cell)?.row {
            guard let video = serials[idx] as? Serial.Item else { return }
            
            guard !cell.downloadBtn.isSelected else { return }
            
            let yes = UIAlertAction(title: "Скачать", style: .default, handler: { [weak self] (_) in
                self?.downloadVideo?(video) { action in
                    cell.downloadBtn.isSelected = action
                }
            })
            let no = UIAlertAction(title: "Закрыть", style: .cancel, handler: nil)
            downloadVideoActions?([yes,no])
        }
    }
    
    func buttonClick(_ sender: Any) {
        
    }
}
